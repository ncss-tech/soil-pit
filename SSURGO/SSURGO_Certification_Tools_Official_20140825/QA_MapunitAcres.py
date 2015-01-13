# QA_MapunitAcres.py
#
# 10-25-2013
# Steve Peaslee USDA-NRCS, National Soil Survey Center
#
# Original Coding: Steve Peaslee, National Soil Survey Center, Lincoln, NE
# Modified from MapunitAcre_Apportionment2.py
#
# Input: Areasymbol, Mapunit Polygon layer with MUSYM, MUSYM columns
# Purpose: to calculate area for each mapunit and compare to NASIS MUACRE (NRI) values
#
#     * Spatial reference for database cursor will fail if there is both a
#       definition query and a selection applied to a layer. No error returned
#       and difficult to detect this situation. Maybe add check for abs value
#       of all coordinates <= 180 and throw error if found??
#
# Fixed problem with parsing HTML from NASIS (thought it was fixed once before!)
# Small change in the way that rounding largest mapunit is reported
# Added option to skip check for matching MUKEYs between NASIS and spatial
#
# Upgrade to NASIS 6.2 introduced a new HTML parsing error. Fixed.
#
# 10-17-2012
# Modified to export MUKEY values to output text file to eliminate possibility of updating wrong mapunit in NASIS.
# 10-31-2013

## ===================================================================================
class MyError(Exception):
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
                arcpy.AddMessage("    ")
                arcpy.AddError(string)

    except:
        pass

## ===================================================================================
def errorMsg():
    try:
        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        theMsg = tbinfo + " \n" + str(sys.exc_type)+ ": " + str(sys.exc_value)
        PrintMsg(theMsg, 2)

    except:
        PrintMsg("Unhandled error in unHandledException method", 2)
        pass

## ===================================================================================
def FindField(theTable, chkField):
    # Check table or featureclass to see if specified field exists
    # Set workspace before calling FindField
    try:
        if arcpy.Exists(theTable):
            # First get the unqualified name of the field to be found
            theNameList = arcpy.ParseFieldName(chkField)
            theCnt = len(theNameList.split(",")) - 1
            chkField = theNameList.split(",")[theCnt].strip()

            # Now compare the unqualified name of each field in the table with the chkField
            theDesc = arcpy.Describe(theTable)
            theFields = theDesc.Fields
            #theField = theFields.next()
            # Get the number of tokens in the fieldnames
            theNameList = arcpy.ParseFieldName(theFields[0].Name)
            theCnt = len(theNameList.split(",")) - 1

            for theField in theFields:
            #while theField:
                theNameList = arcpy.ParseFieldName(theField.Name)
                theFieldname = theNameList.split(",")[theCnt].strip()

                if theFieldname.upper() == chkField.upper():
                    return theField.Name

                #theField = theFields.next()

            return ""

        else:
            PrintMsg("\tTable or featureclass " + os.path.basename(theTable) + " does not exist", 0)
            return ""

    except:
        errorMsg()
        return ""

## ===================================================================================
def GetWC(theFC):
    # Get workspace and featureclass information
    # Use this information to return correct wildcard character for queries
    try:

        # Determine workspace type so correct wildcard can be used
        # At 9.2 SP4 there are bugs in the workspace description methods
        # The following code contains workarounds

        srch = "\\"
        rep = "/"

        # Get fullpath if this is a featurelayer
        thePath = arcpy.Describe(theFC).CatalogPath
        theWS = os.path.dirname(thePath)
        theWS = string.replace(theWS, srch, rep)
        theExtension = theWS[len(theWS) - 4:len(theWS)]
        wsDesc = arcpy.Describe(theWS)
        theDataType = wsDesc.datatype

        if theDataType == "FeatureDataset":
            # Move up one level to find workspace
            theWS = os.path.dirname(theWS)
            theExtension = theWS[len(theWS) - 4:len(theWS)]
            wsDesc = arcpy.Describe(theWS)
            theDataType = wsDesc.datatype

        if theDataType == "Workspace":
            # Problem at 9.2, geoprocessor doesn't identify remote databases correctly
            theWSType = wsDesc.workspacetype

            if theWSType == "LocalDatabase":
                # Either Personal GDB or File GDB
                if theExtension == ".gdb":
                    theWC = '%'
                    theDL1 = '"'
                    theDL2 = '"'

                elif theExtension == ".mdb":
                    theWC = '*'
                    theDL1 = '['
                    theDL2 = ']'

                elif theExtension in ".sde,.gds":
                    # problem with 9.2
                    theWC = '%'
                    theDL1 = '"'
                    theDL2 = '"'

                else:
                    theWC = '%'
                    err = "Unknown type of LocalDatabase"
                    raise MyError, err

            elif theWSType == "RemoteDatabase":
                theWC = '%'
                theDL1 = '"'
                theDL2 = '"'

        elif theDataType == "File":
            theWC = '%'
            theDL1 = '"'
            theDL2 = '"'

        elif theDataType == "Coverage":
            theWC = '%'
            theDL1 = '"'
            theDL2 = '"'

        elif theDataType == "Folder":
            theExtension = thePath[len(thePath) - 4:len(thePath)]

            if theExtension == ".shp":
                theWC = '%'
                theDL1 = '"'
                theDL2 = '"'

            elif theExtension == ".lyr":
                err = "Unable to handle layer (.lyr) files"
                raise MyError, err

            else:
                err = "Unknown Data Type: " + theDataType + " with " + theExtension + " file extension"
                raise MyError, err

        else:
            err = "Unknown Data Type: " + theDataType + " with " + theExtension + " file extension"
            raise MyError, err

        env.workspace = theWS
        del theWS
        return [theWC,theDL1,theDL2]

    except MyError, e:
        PrintMsg(str(e) + " \n", 2)

    except:
        errorMsg()

## ===================================================================================
def NASIS_List(theAreasymbol, theURL, theParameter):
    # Create a dictionary of NASIS MUSYM values
    #
    try:
        dNASIS = dict()

        # Add theAreasymbol to the end of theParameters string
        theParameter = theParameter + theAreasymbol

        theURL = theURL + '&' + theParameter
        theParameter = None
        theReport = urllib.urlopen(theURL, theParameter)

        mapunitCnt = 0

        for theValue in theReport:
            theValue = theValue[theValue.rfind(">") + 1:].strip()

            if len(theValue) > 0:

                if len(theValue.split()) > 1:
                    PrintMsg(theValue, 2)
                    return None

                mapunitCnt += 1

                if not dNASIS.has_key(theValue):
                    dNASIS[theValue] = mapunitCnt
                    #PrintMsg("\tAdding " + theValue + " to NASIS list" ,0)

        #PrintMsg("Found " + str(mapunitCnt) + " mapunits in NASIS", 1)
        del theReport
        return dNASIS

    except IOError:
        err = "IOError. Failed to retrieve MUSYM values from LIMS server"
        arcpy.AddError(err + " \n")
        return dNASIS

    except:
        errorMsg()
        return dNASIS

## ===================================================================================
def Layer_List(theInput, theAreasymbol, bFiltered):
    # Retrieve list of MUSYM and MUKEY values from input layer

    try:
        # Check 'theInput' argument. Determine whether it is table, featurelayer
        # or featureclass.
        # Again, relying upon ArcTool interface to filter out incorrect types.
        #
        theDesc = arcpy.Describe(theInput)
        theDataType = theDesc.DataType
        theSQL = ""
        dMusyms =dict()
        dMukeys = dict

        if bFiltered:
            theWCList = GetWC(theInput)

            if theWCList is None:
                return dMusyms, dMukeys

            theWC = theWCList[0]
            theDL1 = theWCList[1]
            theDL2 = theWCList[2]
            DAreasymbolField = theDL1 + "AREASYMBOL" + theDL2
            theSQL = DAreasymbolField + " = '" + theAreasymbol + "'"

        # Make sure input layer has MUSYM field
        #
        if theDataType.upper() == "FEATURELAYER":
            theFeatureclass = theDesc.Featureclass
            theName = theInput
            theWS = os.path.dirname(theFeatureclass.CatalogPath)
            env.workspace = theWS
            musymField = FindField(theInput, "MUSYM")
            mukeyField = FindField(theInput, "MUKEY")
            theShapeField = theFeatureclass.ShapeFieldName
            theFields = [musymField, mukeyField, "SHAPE@AREA"]

            if musymField == "":
                return dMusyms, dMukeys

            else:
                # Make sure entire featureclass is being checked unless filtered by AREASYMBOL
                # Apply selection if needed
                layerCnt = int(arcpy.GetCount_management(theInput).getOutput(0))
                totalCnt = int(arcpy.GetCount_management(theFeatureclass.CatalogPath).getOutput(0))

                if layerCnt == 0 or totalCnt == 0:
                    PrintMsg("Error. Zero records selected for comparison in featurelayer (" + theInput + ")", 2)
                    return dMusyms, dMukeys

                if layerCnt != totalCnt:
                    PrintMsg(" \nChecking " + Number_Format(layerCnt, 0, True) + " of " + \
                                   Number_Format(totalCnt, 0, True) + " selected features in featurelayer (" + theInput + ")", 1)

                else:
                    PrintMsg(" \nAll " + Number_Format(totalCnt, 0, True) + \
                                   " features are being checked in featurelayer: " + theInput, 1)

                theCursor = arcpy.da.SearchCursor(theName, theFields, theSQL)

        else:
            # Input layer is a featureclass
            totalCnt = int(arcpy.GetCount_management(theDesc.CatalogPath).getOutput(0))
            theWS = os.path.dirname(theInput)
            theName = os.path.basename(theInput)
            env.workspace = theWS
            musymField = FindField(theInput, "MUSYM")
            mukeyField = FindField(theInput, "MUKEY")
            theShapeField = theDesc.ShapeFieldName
            theFields = [musymField, mukeyField, "SHAPE@AREA"]

            if musymField == "":
                return dMusyms, dMukeys

            if bFiltered:
                # Create featurelayer from featureclass
                layerCnt = int(arcpy.GetCount_management(theInput).getOutput(0))
                PrintMsg(" \n" + Number_Format(layerCnt, 0, True) + " of " + \
                           Number_Format(totalCnt) + " records are being checked in " + theDataType.lower() + ": " + theName, 1)

                theCursor = arcpy.da.SearchCursor(theInput, theFields, theSQL )

        # Use cursor to populate dictionary with list of MUSYM values in featurelayer
        #
        dMusyms = dict()
        dMukeys = dict()
        mapunitCnt = 0

        if theCursor is None:
            PrintMsg("\tFailed to create database cursor on Input Layer", 2)
            return dMusyms, dMukeys

        if arcpy.Exists(theInput):

            for theRec in theCursor:
                # theFields = [theField, mukeyField, theShapeField]
                # read each table record and load dictionary
                theMUSYM = str(theRec[0])
                theMUKEY = str(theRec[1])
                theArea = theRec[2]

                if not theMUSYM in dMusyms:
                    mapunitCnt += 1
                    dMusyms[theMUSYM] = theMUSYM
                    dMukeys[theMUKEY] = theArea

                else:
                    dMusyms[theMUSYM] = theMUSYM
                    dMukeys[theMUKEY] = dMukeys[theMUKEY] + theArea

            del theCursor
            del theRec

            if bFiltered and theDataType.upper() == "FEATURELAYER":
                arcpy.SelectLayerByAttribute_management (theInput, "CLEAR_SELECTION")

            return dMusyms, dMukeys


        else:
            PrintMsg(" \nCould not find Input Layer (" + theName + ")", 2)
            return dMusyms, dMukeys

    except:
        PrintMsg(" \nProblem retrieving MUSYM values from theInput layer", 2)
        errorMsg()
        del theCursor
        del theRec
        return dMusyms, dMukeys

## ===================================================================================
def CompareMusym(dNASIS, dMusyms):
    #
    # Compare database contents with layer contents
    try:
        # Compare database MUSYM values with Layer MUSYM values
        #
        #PrintMsg("\nChecking spatial mapunits against NASIS", 1)
        missingLayer = []

        for theMUSYM in dNASIS.keys():
            if not theMUSYM in dMusyms:
                missingLayer.append(theMUSYM)

        layerCnt = len(missingLayer)

        if layerCnt > 0:
            missingLayer = str(missingLayer).replace("[", "")
            missingLayer = str(missingLayer).replace("]", "")

        if layerCnt > 0:
            if layerCnt == 1:
                PrintMsg(" \nFound one MUSYM value) in database that is not present in the input layer:", 2)

            else:
                PrintMsg(" \nFound " + str(layerCnt) + " MUSYM values in database that are not present in the input layer:", 2)

            PrintMsg(missingLayer, 1)
            return False

        # Compare layer MUSYM values with NASIS
        #
        missingNASIS = []

        for theMUSYM in dMusyms.keys():
            if not theMUSYM in dNASIS:
                missingNASIS.append(theMUSYM)

        dbCnt = len(missingNASIS)

        if dbCnt > 0:
            PrintMsg(" \nFound " + Number_Format(dbCnt, 0, True) + " MUSYM value(s) in layer that is not present in database:", 1)
            PrintMsg(str(missingNASIS)[1:-1], 1)
            return False

        return True

    except:
        errorMsg()
        return False

## ===================================================================================
def GetNRI_Acres(theAreasymbol, theURL, theParameter):
    # Retrieve NRI acres for the specified soil survey area
    #
    try:
        PrintMsg(" \nRetrieving NRI acres for survey area '" + theAreasymbol + "' from NASIS", 1)

        # Add theAreasymbol to the end of theParameter string
        theParameter = theParameter + theAreasymbol
        theURL = theURL + theParameter
        theParameter = None
        theReport = urllib.urlopen(theURL, theParameter)

        theAcres = 0
        iCnt = 0
        sFind = '<div id="ReportData">'  # HTML string containing NRI acres value. Only line with data.

        for theValue in theReport:
            iFind = theValue.rfind(sFind)

            if iFind > -1:
                theValue = theValue[20:]
                theAcres = int(theValue.split("=")[1])
                break

        del theReport
        return theAcres

    except IOError:
        PrintMsg("IOError. Failed to retrieve NRI acres from NASIS", 2)
        errorMsg()
        return 0

    except:
        errorMsg()
        return 0

## ===================================================================================
def GetMapunitAcres(dMukeys, NRI_Acres, theUnits, theRptFile):
    #
    # Create text file containing MUKEY and ACRES
    #
    # feet_us to meters conversion =  0.3048006096012192
    # meters to acres conversion 4046.873
    #
    # dMukeys contains the spatial area in square meters or feet, depending upon the coordinate system
    # 10-17-2012 alter output to incorporate areasymbol and mukey instead of musym

    theTotalAcres = 0
    dMusyms2 = dict()  # create dictionary containing acres for each MUSYM value

    if theUnits.upper() == "METER":
        theConv = 4046.873

    elif theUnits.upper() == "FOOT_US":
        theConv = 43560.0

    else:
        PrintMsg(" \nInvalid XY units, acres not calculated (" + theUnits + ")", 2)
        return False

    try:
        # Calculate spatial acres and store in second dictionary object
        for theMUKEY in dMukeys.keys():
            theArea = dMukeys[theMUKEY]
            theAcres = theArea / theConv
            dMusyms2[theMUKEY] = theAcres
            theTotalAcres = theTotalAcres + theAcres

        PrintMsg(" \nTotal spatial acres = " + Number_Format(theTotalAcres, 1, True), 1)
        PrintMsg("Total NRI acres = " + Number_Format(NRI_Acres, 1, True), 1)

        theAdj = NRI_Acres / theTotalAcres
        theTotalAcres2 = 0
        theMaxMUSYM = ""
        theMaxAcres = 0
        dMukeys.clear()

        if theAdj < 0.9 or theAdj > 1.1:
            PrintMsg("Acreage conversion factor (spatial to NRI): " + str(theAdj), 2)

        else:
            PrintMsg("Acreage conversion factor (spatial to NRI): " + str(theAdj), 1)

        for theMUKEY in sorted(dMusyms2.keys()):
            theAcres = int(round(theAdj * dMusyms2[theMUKEY]))
            dMukeys[theMUKEY] = theAcres
            theTotalAcres2 = theAcres + theTotalAcres2

            if theAcres > theMaxAcres:
                theMaxAcres = theAcres
                theMaxMUSYM = theMUKEY

        # Apply adjustment acres to largest mapunit
        beforeSize = dMukeys[theMaxMUSYM]
        muAdj = int(NRI_Acres) - theTotalAcres2
        dMukeys[theMaxMUSYM] = dMukeys[theMaxMUSYM] + muAdj

        if muAdj <> 0:
            if muAdj > 0:
                PrintMsg("Adjusting largest mapunit '" + theMaxMUSYM.strip() + "' up from " + Number_Format(beforeSize, 0, True) + " acres to " + Number_Format(dMukeys[theMaxMUSYM], 0, True) + " acres", 1)

            else:
                PrintMsg("Adjusting largest mapunit '" + theMaxMUSYM.strip() + "' down from " + Number_Format(beforeSize, 0, True) + " acres to " + Number_Format(dMukeys[theMaxMUSYM], 0, True) + " acres", 1)

        if arcpy.Exists(theRptFile):
            arcpy.Delete_management(theRptFile)

        fh = open(theRptFile, "a")
        PrintMsg(" \n          MUKEY          ACRES", 1)
        PrintMsg("      ========================", 1)
        rptString = ""
        iColumn = 15

        for theMUKEY in sorted(dMukeys.keys()):
            theAcres = dMukeys[theMUKEY]
            rptString = rptString + theMUKEY.strip() + "|" + str(dMukeys[theMUKEY]) + "\n"
            sAcres = Number_Format(dMukeys[theMUKEY], 0, True)
            sAcres = (iColumn - len(sAcres)) * " " + sAcres
            sMukey = (iColumn - len(theMUKEY)) * " " + theMUKEY
            PrintMsg(sMukey + sAcres, 0)

        rptString = rptString.rstrip(" \n")
        fh.write(rptString)
        fh.close()
        return True

    except:
        errorMsg()
        return False

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
        return False

## ===================================================================================
## ====================================== Main Body ==================================
# Import modules
import sys, string, os, locale, arcpy, traceback, urllib
from arcpy import env

try:
    # Create geoprocessor object
    progLoc = "Main Setup"

    # Get input parameters
    #
    theInput = arcpy.GetParameterAsText(0)
    theAreasymbol = arcpy.GetParameterAsText(1).upper()
    bCorrelated = arcpy.GetParameter(2)
    bFiltered = True

    # Define output text file
    theRptFile = r"C:\temp\musymacres.txt"

    # Make sure input has a projected coordinate system
    theDesc = arcpy.Describe(theInput)
    theCSType = theDesc.SpatialReference.Type.upper()
    theUnits = theDesc.SpatialReference.LinearUnitName

    if theCSType != "PROJECTED":
        err = "Input layer does not have the required projected coordinate system"
        raise MyError, err

    # First compare spatial mapunits with NASIS mapunits to make sure nothing is missing
    #
    # Create dictionary of MUSYM values retrieved from input layer
    #
    theURL = r"https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?"
    theParameter = "report_name=WEB-Mapunits%20by%20area%20symbol&area_sym="
    dMusyms, dMukeys = Layer_List(theInput, theAreasymbol, bFiltered)

    if len(dMukeys) > 0:

        if bCorrelated:
            # Create dictionary of MUSYM values retrieved from NASIS
            #
            dNASIS = NASIS_List(theAreasymbol, theURL, theParameter)

            if not dNASIS is None:
                if len(dNASIS) > 0:

                    # Compare MUSYM values in each dictionary
                    #
                    bSame = CompareMusym(dNASIS, dMusyms)

                    if bSame:

                        # Get NRI county acreage value from NASIS
                        #
                        theParameter = "report_name=WEB-area+acres&asymbol="

                        NRI_Acres = GetNRI_Acres(theAreasymbol, theURL, theParameter)

                        # Test 'theAreasymbol' argument for standard 5 character length
                        #
                        if len(theAreasymbol) > 5:
                            PrintMsg(" \nWarning, the specified AREASYMBOL is greater than 5 characters in length", 0)

                        # Calculate adjusted NRI acres for each MUSYM
                        #
                        if NRI_Acres > 0:

                            # get dictionary containing MUKEY
                            #bAdjusted = GetMapunitAcres(dMusyms, NRI_Acres, theUnits, theRptFile)
                            bAdjusted = GetMapunitAcres(dMukeys, NRI_Acres, theUnits, theRptFile)

                            if bAdjusted:
                                PrintMsg(" \nOutput file: " + theRptFile, 1)

                            PrintMsg(" \n" + os.path.basename(sys.argv[0]) + " script finished\n" , 1)

                        else:
                            PrintMsg("Error. NRI acreage for " + theAreasymbol + " not populated in NASIS\n", 2)

                    else:
                        PrintMsg("Please fix problem with missing mapunits and then rerun tool", 2)

        else:
            # process without checking for matching mapunits (NASIS and spatial data)
            # Get NRI county acreage value from NASIS
            #
            theParameter = "report_name=WEB-area+acres&asymbol="
            NRI_Acres = GetNRI_Acres(theAreasymbol, theURL, theParameter)

            # Test 'theAreasymbol' argument for standard 5 character length
            #
            if len(theAreasymbol) > 5:
                PrintMsg(" \nWarning, the specified AREASYMBOL is greater than 5 characters in length", 0)

            # Calculate adjusted NRI acres for each MUSYM
            #
            if NRI_Acres > 0:
                #bAdjusted = GetMapunitAcres(dMusyms, NRI_Acres, theUnits, theRptFile)
                bAdjusted = GetMapunitAcres(dMukeys, NRI_Acres, theUnits, theRptFile)

                if bAdjusted:
                    PrintMsg(" \nOutput file: " + theRptFile, 1)

                PrintMsg(" \n" + os.path.basename(sys.argv[0]) + " script finished\n" , 1)

            else:
                PrintMsg("Error. NRI acreage for " + theAreasymbol + " not populated in NASIS\n", 2)

# Exceptions block
#
except MyError, e:
    PrintMsg(str(err) + " \n", 2)

except:
    errorMsg()


