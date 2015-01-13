# SSURGO_BatchDownload.py
#
# Download SSURGO data from Web Soil Survey
#
# Uses Soil Data Access query to generate choicelist and URLs for each survey
#
# Two different tools call this script. One tool uses an Areasymbol wildcard to
# select surveys for download. The other uses an SAPOLYGON layer to generate a list
# of Areasymbol values to select surveys for download.
#
# Requires MS Access to run optional text file import for a custom SSURGO Template DB,
# as well as a modification to the VBA in the Template DB. Name of macro is BatchImport

# There are a lot of problems with WSS 3.0. One issue is trying to determine which surveys have
# spatial data. Normally this should be sapubstatuscode = 2.
# According to Gary, there is a finer level of detail available in the sastatusmap table.
# The columns tabularmudist and spatialmudist tell what kind of mapunit data is present in either the
# tabular or spatial portions. The possible values are:
#
# 1 = has ordinary mapunits and no NOTCOM mapunits
# 2 = has both ordinary and NOTCOM mapunits
# 3 = has only NOTCOM mapunits
# 4 = has no mapunits at all
#
# 10-31-2013
# 11-22-2013
# 01-08-2014
# 01-16-2014 Bad bug, downloads and unzips extra copy of some downloads. fixed.
# 01-22-2014 Modified interface to require that one of the batchimport mdb files be used.
#            Posted all available state template databases to NRCS-GIS sharepoint
#
# Looking at potential for getting old downloads from the Staging Server. Lots of issues to consider...
# Staging Server URL requires E-Auth and has subdirectories
# 04-16-2014 https://soils-staging.sc.egov.usda.gov/NASIS_Export/Staging2Ssurgo/
#
# 05-13-2014 Modified unzip routine to handle other subfolder names at version 3.1 of WSS.
#
# 08-07-2014 Added function to find MS Access application by searching the Registry
# Looks under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths

## ===================================================================================
class MyError(Exception):
    pass

## ===================================================================================
def errorMsg():
    try:
        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        theMsg = tbinfo + " \n" + str(sys.exc_type)+ ": " + str(sys.exc_value) + " \n"
        PrintMsg(theMsg, 2)

    except:
        PrintMsg("Unhandled error in errorMsg method", 2)
        pass

## ===================================================================================
def PrintMsg(msg, severity=0):
    # Adds tool message to the geoprocessor
    #
    #Split the message on \n first, so that if it's multiple lines, a GPMessage will be added for each line
    try:
        for string in msg.split('\n'):
            #Add a geoprocessing message (in case this is run as a tool)
            if severity == 0:
                arcpy.AddMessage(string)

            elif severity == 1:
                arcpy.AddWarning(string)

            elif severity == 2:
                arcpy.AddError(" \n" + string)

    except:
        pass

## ===================================================================================
def Number_Format(num, places=0, bCommas=True):
    try:
    # Format a number according to locality and given places
        #locale.setlocale(locale.LC_ALL, "")
        if bCommas:
            theNumber = locale.format("%.*f", (places, num), True)

        else:
            theNumber = locale.format("%.*f", (places, num), False)
        return theNumber

    except:
        errorMsg()
        return ""

## ===================================================================================
def CheckMSAccess():
    # Make sure this computer has MS Access installed so that the tabular import will run

    try:
        msa = "MSACCESS.EXE"
        aReg = ConnectRegistry(None, HKEY_LOCAL_MACHINE)
        aKey = OpenKey(aReg, r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths")
        acccessPath = ""

        for i in range(1024):
            keyName = EnumKey(aKey, i)

            if keyName == msa:
                subKey = OpenKey(aKey, keyName)
                installPath = QueryValueEx(subKey, "Path")
                accessPath = os.path.join(installPath[0], msa)
                break

        return accessPath

    except WindowsError:
        return ""

    except:
        errorMsg()
        return ""

## ===================================================================================
def GetPublicationDate(areaSym):
    # Not being used at this time
    # Alternate method of getting SSURGO publication date using SDM Access query
    #
    # This should use SASTATUSMAP table instead of SACATALOG
    # Add 'AND SAPUBSTATUSCODE = 2'
    import time, datetime, httplib, urllib2
    import xml.etree.cElementTree as ET

    try:

        # date formatting
        #    today = datetime.date.today()
        #    myDate = today + datetime.timedelta(days = -(self.params[0].value))
        #    myDate = str(myDate).replace("-","")
        #    wc = "'" + self.params[1].value + "%' AND SAVEREST > '" + myDate + "'"

        # return list sorted by date
        #SELECT S.AREASYMBOL, CONVERT (varchar(10), [SAVEREST], 126) AS SDATE FROM SACATALOG S WHERE AREASYMBOL LIKE 'KS%'

        sQuery = "SELECT CONVERT(varchar(10), [SAVEREST], 126) AS SAVEREST FROM SACATALOG WHERE AREASYMBOL = '" + areaSym + "'"
        sQuery = "SELECT CONVERT(varchar(10), [SAVEREST], 126) AS SAVEREST FROM SASTATUSMAP WHERE AREASYMBOL = '" + areaSym + "' AND SAPUBSTATUSCODE = 2"

        # Send XML query to SDM Access service
        #
        sXML = """<?xml version="1.0" encoding="utf-8"?>
    <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
      <soap12:Body>
        <RunQuery xmlns="http://SDMDataAccess.nrcs.usda.gov/Tabular/SDMTabularService.asmx">
          <Query>""" + sQuery + """</Query>
        </RunQuery>
      </soap12:Body>
    </soap12:Envelope>"""

        dHeaders = dict()
        dHeaders["Host"] = "sdmdataaccess.nrcs.usda.gov"
        dHeaders["Content-Type"] = "text/xml; charset=utf-8"
        dHeaders["SOAPAction"] = "http://SDMDataAccess.nrcs.usda.gov/Tabular/SDMTabularService.asmx/RunQuery"
        dHeaders["Content-Length"] = len(sXML)
        sURL = "SDMDataAccess.nrcs.usda.gov"

        # Create SDM connection to service using HTTP
        conn = httplib.HTTPConnection(sURL, 80)

        # Send request in XML-Soap
        conn.request("POST", "/Tabular/SDMTabularService.asmx", sXML, dHeaders)

        # Get back XML response
        response = conn.getresponse()
        xmlString = response.read()

        # Close connection to SDM
        conn.close()

        # Convert XML to tree format
        tree = ET.fromstring(xmlString)

        iCnt = 0
        # Create empty value list
        valList = list()

        # Iterate through XML tree, finding required elements...
        for rec in tree.iter():

            if rec.tag == "SAVEREST":
                # get the YYYYMMDD part of the datetime string
                # then reformat to match SQL query
                sdmDate = str(rec.text).split(" ")[0]

        return sdmDate

    except:
        errorMsg()
        return 0

## ===================================================================================
def GetTemplateDate(newDB):
    # Get SAVEREST date from previously existing Template database
    # Use it to compare with the date from the WSS dataset
    # If the existing database is same or newer, it will be kept and the WSS version skipped
    try:
        if not arcpy.Exists(newDB):
            return 0

        saCatalog = os.path.join(newDB, "SACATALOG")
        dbDate = 0

        if arcpy.Exists(saCatalog):
            with arcpy.da.SearchCursor(saCatalog, ("SAVEREST"), "[AREASYMBOL] = '" + areaSym + "'") as srcCursor:
                for rec in srcCursor:
                    dbDate = str(rec[0]).split(" ")[0]

            del saCatalog
            del newDB
            return dbDate

        else:
            # unable to open SACATALOG table in existing dataset
            # return 0 which will result in the existing dataset being overwritten by a new WSS download
            return 0

    except:
        errorMsg()
        return 0

## ===================================================================================
def GetDownload(areasym, surveyDate, importDB):
    # download survey from Web Soil Survey URL and return name of the zip file
    # want to set this up so that download will retry several times in case of error
    # return empty string in case of complete failure. Allow main to skip a failed
    # survey, but keep a list of failures
    #
    # Only the version of zip file without a Template database is downloaded. The user
    # must have a locale copy of the Template database that has been modified to allow
    # automatic tabular imports.

    # create URL string from survey string and WSS 3.0 cache URL
    baseURL = "http://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/"

    try:
        # only use URL without Template DB
        zipName = "wss_SSA_" + areaSym + "_[" + surveyDate + "].zip"
        zipURL = baseURL + zipName

        PrintMsg("\tDownloading zipfile from Web Soil Survey...", 0)

        # number of attempts allowed
        attempts = 3

        for i in range(attempts):
            try:
                # download zip file from Web Soil Survey
                request = urlopen(zipURL)

                # save zip file to a local folder
                local_zip = os.path.join(outputFolder, zipName)

                # make sure the output zip file doesn't already exist
                if os.path.isfile(local_zip):
                    os.remove(local_zip)

                output = open(local_zip, "wb")
                output.write(request.read())
                output.close()

                # if we get this far then the download succeeded
                return zipName

            except HTTPError, e:
                PrintMsg("\t\t" + areaSym + " encountered HTTP Error (" + str(e.code) + ")", 1)
                sleep(i * 3)

            except URLError, e:
                PrintMsg("\t\t" + areaSym + " encountered URL Error: " + str(e.reason), 1)
                sleep(i * 3)

            except socket.timeout, e:
                PrintMsg("\t\t" + areaSym + " encountered server timeout error", 1)
                sleep(i * 3)

            except socket.error, e:
                PrintMsg("\t\t" + areasym + " encountered Web Soil Survey connection failure", 1)
                sleep(i * 3)

            except:
                # problem deleting partial zip file after connection error?
                # saw some locked, zero-byte zip files associated with connection errors
                PrintMsg("\tFailed to download zipfile", 0)
                sleep(1)
                return ""

        # if we get this far, the download failed
        return ""

    except:
        # zipURL
        errorMsg()
        return ""

## ===================================================================================
# main
# Import system modules
import arcpy, sys, os, locale, string, traceback, shutil, zipfile, subprocess, glob, socket
from urllib2 import urlopen, URLError, HTTPError
from arcpy import env
from _winreg import *
from time import sleep

try:
    arcpy.OverwriteOutput = True

    # Script arguments...
    wc = arcpy.GetParameter(0)
    dateFilter = arcpy.GetParameter(1)
    outputFolder = arcpy.GetParameterAsText(2)
    surveyList = arcpy.GetParameter(3)
    importDB = arcpy.GetParameterAsText(4)
    bRemoveTXT = arcpy.GetParameter(5)
    #msAccess = arcpy.GetParameterAsText(6)

    msAccess = CheckMSAccess()

    if msAccess == "":
        raise MyError, "Microsoft Access: application not found, unable to import tabular data \n "

    if not arcpy.Exists(msAccess):
        raise MyError, "MS Access install path incorrect (" +  msAccess + ") \n "

    PrintMsg(" \n" + str(len(surveyList)) + " soil survey(s) selected for WSS download", 0)

    # set workspace to output folder
    env.workspace = outputFolder

    # Create ordered list by Areasymbol
    asList = list()
    asDict = dict()

    for survey in surveyList:
        env.workspace = outputFolder
        surveyInfo = survey.split(",")
        areaSym = surveyInfo[0].strip().upper()
        asList.append(areaSym)
        asDict[areaSym] = survey

    asList.sort()

    failedList = list()  # track list of failed downloads
    skippedList = list() # track list of downloads that were skipped because a newer version already exists
    iGet = 0
    arcpy.SetProgressor("step", "Downloading SSURGO data...",  0, len(asList), 1)

    for areaSym in asList:
        # Run import process in order of Areasymbol value
        iGet += 1
        survey = asDict[areaSym]
        env.workspace = outputFolder
        surveyInfo = survey.split(",")
        areaSym = surveyInfo[0].strip().upper()

        # get date string
        surveyDate = surveyInfo[1].strip()

        # get survey name
        surveyName = surveyInfo[2].strip()

        # set standard final path and name for template database
        newFolder = os.path.join(outputFolder, "soil_" + areaSym.lower())

        # set standard name and path for SSURGO Template database
        newDB = os.path.join(os.path.join(newFolder, "tabular"), "soil_d_" + areaSym.lower() + ".mdb")

        if os.path.isdir(newFolder):
            if os.path.isfile(newDB):
                dbDate = GetTemplateDate(newDB)

            else:
                dbDate = 0

            #PrintMsg(" \nLocal dataset for " + areaSym + " already exists (" + str(surveyDate) + ")", 0)
            PrintMsg(" \nLocal dataset for " + areaSym + " already exists (" + str(dbDate) + ")", 0)
            #PrintMsg("\tDownload Date:    " + str(surveyDate), 0)


            if dbDate == 0:
                # Could not get SAVEREST date from database, assume old dataset is incomplete and overwrite
                PrintMsg("\tLocal dataset is incomplete and will be overwritten", 1)
                shutil.rmtree(newFolder, True)
                time.sleep(3)
                bNewer = True

                if arcpy.Exists(newFolder):
                    raise MyError, "Failed to delete old dataset (" + newFolder + ")"

            else:
                # Compare SDM date with local database date
                if int(str(surveyDate).replace("-","")) > int(str(dbDate).replace("-","")):
                    # Downloaded data is newer than the local copy. Delete and replace with new data.
                    #
                    #PrintMsg("\tReplacing local database with newer download", 1)
                    bNewer = True
                    # delete old data folder
                    shutil.rmtree(newFolder, True)
                    time.sleep(3)

                    if arcpy.Exists(newFolder):
                        raise MyError, "Failed to delete old dataset (" + newFolder + ")"

                else:
                    # according to the filename-date, the WSS version is the same or older
                    # than the local Template DB, skip download for this survey
                    if int(str(surveyDate).replace("-","")) == int(str(dbDate).replace("-","")):
                        PrintMsg("\tSkipping download. Local copy matches Web Soil Survey", 0)

                    else:
                        PrintMsg("\tSkipping download. Local copy of data is newer (" + str(dbDate) + ") than the WSS data!?", 1)

                    bNewer = False

        else:
            bNewer = True

        if bNewer:
            # Get new SSURGO download or replace an older version of the same survey
            # Otherwise skip download
            #
            PrintMsg(" \nProcessing survey " + areaSym + ":  " + surveyName, 0)
            arcpy.SetProgressorLabel("Downloading survey " + areaSym.upper() + "  (" + Number_Format(iGet, 0, True) + " of " + Number_Format(len(surveyList), 0, True) + ")")

            # Allow for multiple attempts to get zip file
            #
            iTry = 2

            for i in range(iTry):
                # Download the zip file
                # Sometimes a corrupt zip file is downloaded, so a second attempt will be made if the first fails
                try:
                    zipName = GetDownload(areaSym, surveyDate, importDB)

                    if zipName != "":
                        # ??
                        # Need to check, under what circumstances would the zipName = ""
                        # ??
                        local_zip = os.path.join(outputFolder, zipName)

                        if os.path.isfile(local_zip):
                            # got a zip file, go ahead and extract it
                            zipSize = os.stat(local_zip).st_size

                            if zipSize > 0:
                                PrintMsg("\tUnzipping " + zipName + " (" + Number_Format(zipSize, 0, True) + " bytes), to " + outputFolder + "...", 0)

                                with zipfile.ZipFile(local_zip, "r") as z:
                                    # a bad zip file returns exception zipfile.BadZipFile
                                    z.extractall(outputFolder)

                                # remove zip file after it has been extracted,
                                # allowing a little extra time for file lock to clear
                                sleep(3)
                                os.remove(local_zip)

                                # rename output folder to NRCS Geodata Standard for Soils
                                if os.path.isdir(os.path.join(outputFolder, zipName[:-4])):
                                    # this is an older zip file that has the 'wss_' directory structure
                                    os.rename(os.path.join(outputFolder, zipName[:-4]), newFolder)

                                elif os.path.isdir(os.path.join(outputFolder, areaSym.upper())):
                                    # this must be a newer zip file using the uppercase AREASYMBOL directory
                                    os.rename(os.path.join(outputFolder, areaSym.upper()), newFolder)

                                elif os.path.isdir(newFolder):
                                    # this is a future zip file using the correct field office naming convention (soil_ne109)
                                    # it does not require renaming.
                                    pass

                                else:
                                    # none of the subfolders within the zip file match any of the expected names
                                    raise MyError, "Subfolder within the zip file does not match any of the standard names"

                                # get database name from file listing in the new folder
                                env.workspace = newFolder

                                if importDB != "":
                                    # move to tabular folder
                                    env.workspace = os.path.join(newFolder, "tabular")

                                    # copy over master database and run tabular import
                                    PrintMsg("\tCopying selected master template database to tabular folder...", 0)

                                    # copy user specified database to the new folder
                                    shutil.copy2(importDB, newDB)

                                    # Run Auto_Import routine on database
                                    PrintMsg("\tImporting textfiles into the new database " + os.path.basename(newDB) + "...", 0)

                                    #if msAccess == "":
                                    #    msAccess = "C:\\Program Files (x86)\\Microsoft Office\\Office14\\msaccess.exe"

                                    cmdParam = "/nostartup /x BatchImport"
                                    cmd = '"' + msAccess + '" "' + newDB + '" ' + cmdParam
                                    #PrintMsg(" \nCommand: " + test, 0)
                                    subprocess.call(cmd)

                                    # Run the Restore_Auto to rename the 'AutoexecNOT' macro back to the original 'Autoexec'
                                    # This is required to enable the 'REPORTS' dialog to automatically popup
                                    cmdParam = "/nostartup /x RestoreAuto"
                                    cmd = '"' + msAccess + '" "' + newDB + '" ' + cmdParam
                                    #PrintMsg(" \nCommand: " + test, 0)
                                    subprocess.call(cmd)

                                    # Compact database (~30% reduction in mdb filesize)
                                    try:
                                        sleep(1)
                                        arcpy.Compact_management(newDB)
                                        PrintMsg("\tCompacted database", 0)

                                    except:
                                        # Sometimes ArcGIS is unable to compact (locked database?)
                                        # Usually restarting the ArcGIS application fixes this problem
                                        PrintMsg("\tUnable to compact database", 1)

                                    # Add MuName to mapunit polygon shapefile using mapunit.txt
                                    muTxt = os.path.join(os.path.join(newFolder, "tabular"), "mapunit.txt")
                                    muDict = dict()

                                    tabPath = os.path.join(newFolder, "tabular")
                                    spatialFolder = os.path.join(newFolder, "spatial")
                                    env.workspace = spatialFolder

                                    # Some of the tabular only shapefiles on WSS were created as polyline instead of
                                    # polygon. This situation will cause the next line to fail with index out of range
                                    shpList = arcpy.ListFeatureClasses("soilmu_a*", "Polygon")

                                    if len(shpList) == 1:
                                        muShp = shpList[0]
                                        PrintMsg("\tAdding MUNAME to " + muShp, 0)
                                        # add muname column to shapefile
                                        arcpy.AddField_management (muShp, "MUNAME", "TEXT", "", "", 175)

                                        # read mukey and muname into dictionary from mapunit.txt file
                                        with open(muTxt, 'r') as f:
                                            data = f.readlines()

                                        for rec in data:
                                            s = rec.replace('"','')
                                            muList = s.split("|")
                                            muDict[muList[len(muList) - 1].strip()] = muList[1]

                                        # update shapefile using dictionary
                                        with arcpy.da.UpdateCursor(muShp, ("MUKEY","MUNAME")) as upCursor:
                                            for rec in upCursor:
                                                rec[1] = muDict[rec[0]]
                                                upCursor.updateRow (rec)

                                        del muTxt, data, muDict

                                        # Remove all the text files from the tabular folder
                                        if bRemoveTXT:
                                            txtList = glob.glob(os.path.join(tabPath, "*.txt"))
                                            PrintMsg("\tRemoving textfiles...", 0)

                                            for txtFile in txtList:
                                                os.remove(txtFile)

                                    else:
                                        PrintMsg("\tMap unit polygon shapefile not found, 'Tabular-Only' survey?", 2)
                                        failedList.append(areaSym)
                            else:
                                # Zero-byte zip file
                                # download for this survey failed
                                PrintMsg("\tEmpty zip file downloaded for " + areaSym + ": " + surveyName, 1)
                                #failedList.append(areaSym)
                                os.remove(local_zip)
                                break

                        else:
                            # ??
                            # Don't have a zip file, need to find out circumstances and document
                            # ??
                            # rename downloaded database using standard convention, skip import
                            raise MyError, "Missing zip file...."
                            oldDB = arcpy.ListWorkspaces("*", "Access")[0]
                            os.rename(oldDB, newDB)

                        # import FGDC metadata to mapunit polygon shapefile
                        spatialFolder = os.path.join(newFolder, "spatial")
                        env.workspace = spatialFolder
                        shpList = arcpy.ListFeatureClasses("soilmu_a*", "Polygon")

                        if len(shpList) == 1:
                            muShp = shpList[0]
                            PrintMsg("\tImporting metadata for " + muShp, 0)
                            metaData = os.path.join(newFolder, "soil_metadata_" + areaSym.lower() + ".xml")
                            arcpy.ImportMetadata_conversion(metaData, "FROM_FGDC", os.path.join(spatialFolder, muShp), "ENABLED")
                            del spatialFolder, muShp, metaData

                        break
                        # end of successful zip file download

                except:
                    # go back to top to try downloading zip file again
                    errorMsg()
                    PrintMsg("\tProblem with zipfile...", 0)
                    pass

            if not os.path.exists(newDB) and not importDB == "":
                # download for this survey failed
                PrintMsg("\tDownload failed for " + areaSym + ": " + surveyName, 2)
                failedList.append(areaSym)

        else:
            # Existing local dataset is same age or newer than downloaded version
            # skip it
            skippedList.append(areaSym)

        arcpy.SetProgressorPosition()

    if len(failedList) > 0 or len(skippedList) > 0:
        PrintMsg(" \nDownload process finished with the following issues...", 1)

    else:
        PrintMsg(" \nDownload process complete", 0)

    arcpy.SetProgressorLabel("Processing complete...")
    env.workspace = outputFolder

    if len(failedList) > 0:
        PrintMsg("These surveys failed to download properly: " + ", ".join(failedList), 2)

    if len(skippedList) > 0:
        PrintMsg("These surveys were skipped because a more current local version exists: " + ", ".join(skippedList), 1)

    PrintMsg(" ", 0)

except MyError, e:
    # Example: raise MyError, "This is an error message"
    PrintMsg(str(e), 2)

except:
    errorMsg()
