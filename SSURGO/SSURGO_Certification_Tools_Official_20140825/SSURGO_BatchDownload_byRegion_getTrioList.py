import arcpy, sys, os, locale, string, traceback, shutil, zipfile, subprocess, glob, shutil, socket, time, datetime, httplib, urllib2
from urllib2 import urlopen, URLError, HTTPError
from arcpy import env
from time import sleep
import xml.etree.cElementTree as ET

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
def getRegionalAreaSymbolList(ssurgoSSApath):

    areaSymbolList = []

    #onlyBlanks = "\"AREANAME\" IS NULL"
    #onlyID = "\"AREASYMBOL\" LIKE 'MT%'"

    with arcpy.da.SearchCursor(ssurgoSSApath, ("AREASYMBOL")) as cursor:
        for row in cursor:
            areaSymbolList.append(row[0])

    return areaSymbolList

## ===================================================================================
def getSDMaccessDict(areaSymbol):

    # Create empty list that will contain list of 'Areasymbol, AreaName
    sdmAccessDict = dict()

    #for areaSym in areaSymList:

    #sQuery = "SELECT AREASYMBOL, AREANAME, CONVERT(varchar(10), [SAVEREST], 126) AS SAVEREST FROM SASTATUSMAP WHERE AREASYMBOL LIKE '" + areaSymbol + "' AND SAPUBSTATUSCODE = 0 ORDER BY AREASYMBOL"
    sQuery = "SELECT AREASYMBOL, AREANAME, CONVERT(varchar(10), [SAVEREST], 126) AS SAVEREST FROM SASTATUSMAP WHERE AREASYMBOL LIKE '" + areaSymbol + "' ORDER BY AREASYMBOL"

    # This RunQuery runs your own custom SQL or SQL Data Shaping query against the Soil Data Mart database and returns an XML
    # data set containing the results. If an error occurs, an exception will be thrown.

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
    #dHeaders["User-Agent"] = "NuSOAP/0.7.3 (1.114)"
    #dHeaders["Content-Type"] = "application/soap+xml; charset=utf-8"
    dHeaders["Content-Type"] = "text/xml; charset=utf-8"
    dHeaders["Content-Length"] = len(sXML)
    dHeaders["SOAPAction"] = "http://SDMDataAccess.nrcs.usda.gov/Tabular/SDMTabularService.asmx/RunQuery"
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

    areasym = ""
    areaname = ""
    date = ""

    # Iterate through XML tree, finding required elements...
    for rec in tree.iter():

        if rec.tag == "AREASYMBOL":
            areasym = str(rec.text)

        if rec.tag == "AREANAME":
            areaname = str(rec.text)

        if rec.tag == "SAVEREST":
            # get the YYYYMMDD part of the datetime string
            # then reformat to match SQL query
            date = str(rec.text).split(" ")[0]

    #sdmAccessDict[areaSymbol] = (areasym + ",  " + str(date) + ",  " + areaname)
    sdmAccessDict[areaSymbol] = (areasym + "|" + str(date) + "|" + areaname)

    del areasym, areaname, date

    return sdmAccessDict

## ===================================================================================
def GetDownload(areasym, surveyDate):
    # download survey from Web Soil Survey URL and return name of the zip file
    # want to set this up so that download will retry several times in case of error
    # return empty string in case of complete failure. Allow main to skip a failed
    # survey, but keep a list of failures
    #
    # As of Aug 2013, states are using either a state or US 2003 template databases which would
    # result in two possible zip file names. If that changes in the future, these URL will fail

    # UPDATE: 8-13-2013 Need to change the URL, depending upon whether or not a master
    # Template DB is being used!
    # example URL without Template:
    # http://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/wss_SSA_NE001_[2012-08-10].zip

    # create URL string from survey string and WSS 3.0 cache URL
    baseURL = "http://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/"

    try:

        # create two possible zip file URLs, depending on the valid Template databases available
        # Always download dataset with a SSURGO Access template.
        zipName1 = "wss_SSA_" + areaSym + "_soildb_US_2003_[" + surveyDate + "].zip"  # wss_SSA_WI025_soildb_US_2003_[2012-06-26].zip
        zipName2 = "wss_SSA_" + areaSym + "_soildb_" + areaSym[0:2] + "_2003_[" + surveyDate + "].zip"  # wss_SSA_WI025_soildb_WI_2003_[2012-06-26].zip

        zipURL1 = baseURL + zipName1  # http://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/wss_SSA_WI025_soildb_US_2003_[2012-06-26].zip
        zipURL2 = baseURL + zipName2  # http://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/wss_SSA_WI025_soildb_WI_2003_[2012-06-26].zip

        PrintMsg("\tGetting zipfile from Web Soil Survey...", 0)

        # number of attempts allowed
        attempts = 5

        for i in range(attempts):

            try:
                # create a response object for the requested URL to download a specific SSURGO dataset.
                try:
                    # try downloading zip file with US 2003 Template DB first
                    request = urlopen(zipURL1)
                    zipName = zipName1

                except:
                    # if the zip file with US Template DB is not found, try the state template for 2003
                    # if the second attempt fails, it should fall down to the error messages
                    request = urlopen(zipURL2)
                    zipName = zipName2

                # path to where the zip file will be written to
                local_zip = os.path.join(outputFolder, zipName)  # C:\Temp\peaslee_download\wss_SSA_WI025_soildb_WI_2003_[2012-06-26].zip

                # delete the output zip file it exists
                if os.path.isfile(local_zip):
                    os.remove(local_zip)

                # response object is actually a file-like object that can be read and written to a specific location
                output = open(local_zip, "wb")
                output.write(request.read())
                output.close()

                # Download succeeded; return zipName; no need for further attempts
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

        # Download Failed!
        return ""

    except:
        errorMsg()
        return ""


ssurgoSSApath = r'N:\flex\FY2013_SSURGO_archive\FY2013_SSURGO_FGDBs\SSURGO_Soil_Survey_Area.gdb\SSA_Regional_Ownership_MASTER'
outputFolder = r'C:\Temp\peaslee_download'

updateTable = r'N:\flex\FY2013_SSURGO_archive\FY2013_SSURGO_FGDBs\SSURGO_Soil_Survey_Area.gdb\SSA_Regional_Ownership_MASTER'
fields = ('AREANAME')

areaSymList = getRegionalAreaSymbolList(ssurgoSSApath)
#areaSymList = ('MT640','MT642')

for ss in areaSymList:
    print "Processing: " + ss
    sdmAccessDict = getSDMaccessDict(ss)

    survey = sdmAccessDict[ss]
    surveyInfo = survey.split("|")

    # Get Areasymbol, Date, and Survey Name from 'asDict'
    areaSym = surveyInfo[0].strip().upper()  # Why get areaSym again???
    surveyDate = surveyInfo[1].strip()    # Don't need this since we will always get the most current
    surveyName = surveyInfo[2].strip()    #  Adams County, Wisconsin

    #print " \nUpdating survey " + areaSym + ": " + surveyName + " - Version: " + str(surveyDate)

    whereClause = "\"AREASYMBOL\" = " + "'" + areaSym + "'"
    with arcpy.da.UpdateCursor(updateTable, fields, whereClause) as cursor:
        for row in cursor:
            row[0] = surveyName
            print "\tUpdating: " + areaSym + " : " + surveyName
            cursor.updateRow(row)


