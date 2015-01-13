# QA_SelectedSoilFeatures.py
#
# ArcGIS 10.1
#
# Steve Peaslee, USDA-NRCS, National Soil Survey Center
#
# Original code: 06-17-2013
# Last modified: 10-31-2013
#
# Polygon tool used to create a QA layer of only selected soil features (such as Water)
# This QA layer can then be used as part of a visual inspection process
#
class MyError(Exception):
    pass

## ===================================================================================
def PrintMsg(msg, severity=0):
    # Adds tool message to the geoprocessor
    print msg
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
        PrintMsg("Unhandled error in errorMsg method", 2)
        pass

## ===================================================================================
def Number_Format(num, places=0, bCommas=True):
    # Format a number according to locality and given places
    import locale

    try:
        locale.setlocale(locale.LC_ALL, 'en_US.UTF-8') #use locale.format for commafication

    except locale.Error:
        locale.setlocale(locale.LC_ALL, '') #set to default locale (works on windows)

    try:

        import locale


        if bCommas:
            theNumber = locale.format("%.*f", (places, num), True)

        else:
            theNumber = locale.format("%.*f", (places, num), False)

        return theNumber

    except:
        errorMsg()
        return False

## ===================================================================================
def MakeOutLayer(inLayer, sr, inField, valList):
    # Create output featureclass name and set output workspace
    #
    try:
        # Set workspace to that of the input polygon featureclass
        desc = arcpy.Describe(inLayer)
        theCatalogPath = desc.catalogPath
        loc = os.path.dirname(theCatalogPath)
        shapeType = arcpy.Describe(theCatalogPath).shapeType.title()
        inputDT = desc.dataType.upper()
        desc = arcpy.Describe(loc)
        wsDT = desc.dataType.upper()

        if wsDT == "WORKSPACE":
            env.workspace = loc
            ext = ""

        elif wsDT == "FEATUREDATASET":
            env.workspace = os.path.dirname(loc)
            ext = ""

        elif wsDT == "FOLDER":
            env.workspace = loc
            ext = ".shp"

        else:
            PrintMsg(" \nError. " + loc + " is a " + wsDT + " datatype", 2)
            return ""

        # Parse field name in case it is a qualified name
        fieldNames = arcpy.ParseFieldName(inField, env.workspace).split(",")
        fieldName = fieldNames[3].strip()
        #PrintMsg(" \nParsed field name: " + fieldName, 0)

        # finally, set both output featureclass and output featurelayer names
        outLayer = "QA " + shapeType + "s (" + fieldName.title() + ": " + str(",".join(valList)) + ")"
        outFC = arcpy.ValidateTableName ("QA_" + shapeType + "_"  + fieldName.title() + "_" + str("_".join(valList)), env.workspace) + ext


        # clean up previous runs
        if arcpy.Exists(outLayer):
            arcpy.Delete_management(outLayer)

        PrintMsg(" \nOutput featureclass name: " + outFC + " in " + env.workspace + " " + wsDT.lower(), 1)

        return outFC, outLayer

    except:
        errorMsg()
        return ""

## ===================================================================================
def GetFields(fldList):
    # create field info string for output query table, include everything but OID field

    try:
        fldInfo = ""

        for field in fldList:
            if field.type != "OID":
                if fldInfo == "":
                    fldInfo = field.name + " " + field.baseName

                else:
                    fldInfo = fldInfo + ";" + field.name + " " + field.baseName

        #PrintMsg(" \nFieldInfo: " +  fldInfo, 0)
        return fldInfo

    except:
        errorMsg()
        return fldInfo

## ===================================================================================
## main
##

import os, sys, traceback, collections
import arcpy
from arcpy import env

try:

    # single polygon featurelayer as input parameter
    inLayer = arcpy.GetParameterAsText(0)

    # attribute column used in selection
    inField = arcpy.GetParameterAsText(1)

    # selected attribute values that will be used to query the input layer
    valList = arcpy.GetParameter(2)

    # single featurelayer as output parameter
    outLayer = arcpy.GetParameter(3)

    iSelection = int(arcpy.GetCount_management(inLayer).getOutput(0))

    # define output featureclass
    desc = arcpy.Describe(inLayer)
    dt = desc.dataType.upper()
    fldList = desc.fields
    sr = desc.spatialReference

    loc = os.path.dirname(desc.CatalogPath)
    wDesc = arcpy.Describe(loc)
    wDT = wDesc.dataType

    if wDT.upper() == "WORKSPACE":
        env.workspace = loc
        ext = ""

    elif wDT == "FEATUREDATASET":
        env.workspace = os.path.dirname(loc)
        ext = ""

    iVals = len(valList)
    # PrintMsg(" \nFound " + Number_Format(iVals, 0, True) + " unique values", 1)

    if iVals > 0:
        # Get names of the output featureclass and output layer and set output workspace (env)
        outFC, outLayer = MakeOutLayer(inLayer, sr, inField, valList)

        # get field information to include in the output query table
        fldInfo = GetFields(fldList)

        # get field info for the input field

        for fld in fldList:
            if fld.name == inField:
                inFieldType = fld.type.upper()

        # create SQL for SelectByAttribute (only handles text attributes)
        if inFieldType in ("STRING","TEXT"):
            SQL = arcpy.AddFieldDelimiters(env.workspace, inField) + " in (" + "'" + "','".join(valList) + "')"

        else:
            SQL = arcpy.AddFieldDelimiters(env.workspace, inField) + " in (" + ",".join(valList) + ")"

        PrintMsg(" \nSelecting " + desc.shapeType.lower()  + " features where:  " + SQL, 0)

        # Create temporary featurelayer using query and get count
        arcpy.MakeFeatureLayer_management(inLayer, outLayer, SQL)
        iCnt = int(arcpy.GetCount_management(outLayer).getOutput(0))

        # clean up featureclass from a previous run
        if arcpy.Exists(outFC):
            arcpy.Delete_management(outFC)

        # copy query table to a new featureclass
        PrintMsg(" \nCopying '" + outLayer + "' layer with " + str(iCnt) + " features to new featureclass " + outFC, 0)
        arcpy.CopyFeatures_management(outLayer, outFC)
        # add STATUS column to output featureclass
        arcpy.AddField_management(outFC, "Status", "TEXT", "", "", 10, "Status")

        try:
            # if this is ArcMap, create new QA map layer
            mxd = arcpy.mapping.MapDocument("CURRENT")
            arcpy.env.addOutputsToMap = True
            arcpy.MakeFeatureLayer_management(outFC, outLayer)

            # import symbology from layer file
            if desc.shapeType.upper() == "POLYGON":
                lyrFile = os.path.join( os.path.dirname(sys.argv[0]), "Water_Polygon.lyr")
                arcpy.ApplySymbologyFromLayer_management(outLayer, lyrFile)

            elif desc.shapeType.upper() == "POLYLINE":
                lyrFile = os.path.join( os.path.dirname(sys.argv[0]), "Blue_Line.lyr")
                arcpy.ApplySymbologyFromLayer_management(outLayer, lyrFile)

            elif desc.shapeType.upper() == "POINT":
                lyrFile = os.path.join( os.path.dirname(sys.argv[0]), "Water_Point.lyr")
                arcpy.ApplySymbologyFromLayer_management(outLayer, lyrFile)

            # add new QA map layer to the ArcMap TOC
            arcpy.SetParameter(3, outLayer)
            PrintMsg(" \nAdded output layer '" + outLayer + "' to ArcMap", 1)
            PrintMsg(" \nOutput featureclass: " + outFC, 1)
            PrintMsg(" \n ", 1)
            arcpy.SelectLayerByAttribute_management(outLayer, "CLEAR_SELECTION")

        except:
          # Cannot create map layer in ArcCatalog
          PrintMsg(" \nSuccessfully created output featureclass: " + outFC, 1)
          PrintMsg(" \n ", 1)
          pass

    else:
        PrintMsg(" \nUnable to identify unique values for " + inField, 0)

except:
    errorMsg()

