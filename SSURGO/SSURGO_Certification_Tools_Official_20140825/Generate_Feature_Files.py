#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      charles.ferguson
#
# Created:     22/07/2013
# Copyright:   (c) charles.ferguson 2013
# Licence:     <your licence>

#11/19/2013
#added functionality to sort the order in which soil survey areas are processed(alphabetically)
#allowed  featsyms of any length to be processed, a console and report message are added
#added message to console and report if no special features are found, alerting user and reminding that an empty feature file is still created
#-------------------------------------------------------------------------------
class MyError(Exception):
    pass



def errorMsg():

    try:

        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        theMsg = tbinfo + " \n" + str(sys.exc_type)+ ": " + str(sys.exc_value) + " \n"
        arcMsg = "ArcPy ERRORS:\n" + arcpy.GetMessages(2) + "\n"
        PrintMsg(theMsg, 2)
        PrintMsg(arcMsg, 2)

    except:

        PrintMsg("Unhandled error in errorMsg method", 2)



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



def spatialPointValidator(inSPFT):

    try:

        desc = arcpy.Describe(inSPFT)

        if desc.catalogPath[-4:] <> '.shp':
            return False, '\n \'Input Points\' layer is not a shapefile', None, None, None, None

        if not desc.shapeType == 'Point':
            return False, '\n \'Input Points\' layer ' + inSPFT + ' is not a points layer', None, None, None, None

##        if not desc.FIDSet == '':
##            return False, '\nPlease clear your point selection', None, None, None

        fldLst = ['FEATSYM', 'AREASYMBOL']
        for eFld in fldLst:
            if eFld not in [str(field.name) for field in desc.fields]:
                return False, '\nThe field ' + eFld + ' is not located in the attribute table for point layer ' + inSPFT.upper(), None, None, None, None

        areaSymLst = list(set([str(row[0]) for row in arcpy.da.SearchCursor(inSPFT, "AREASYMBOL")]))
        if len(areaSymLst) > 1:
            return False, '\nThere is more than 1 AREASYMBOL in the '+ inSPFT + ' layer', None, None, None, None

        pCount = int(arcpy.GetCount_management(inSPFT).getOutput(0))

        localPointsSet = set([str(row[0]) for row in arcpy.da.SearchCursor(inSPFT, "FEATSYM")])
        localPointsLst = list(localPointsSet)

        #ftMsg = ''
        for eVal in localPointsLst:
            #if len(eVal) > 0 and len(eVal) != 3:
                #ftMsg = ftMsg + 'WARNING: An unusual FEATSYM [' + eVal + '] was found in the spatial data for ' + os.path.basename(inSPFT.upper()[:-4]) + '\n'


            if eVal.find(' ') <> -1:
                return False, 'Invalid FEATSYM encountered ' + inSPFT.upper() + '. Check for empty attributes or extra spaces.', None, None, None, None


        return True, areaSymLst, localPointsLst, localPointsSet, desc.path, pCount

    except:

        # some type of error, return False

        errorMsg()
        return False, "Unable to validate input points layer", None, None, None, None




def spatialLineValidator(inSLFT):

    try:

        desc = arcpy.Describe(inSLFT)

        if desc.catalogPath[-4:] <> '.shp':
            return False, '\n \'Input Lines\' layer is not a shapefile', None, None, None

        if not desc.shapeType == 'Polyline':
            return False, '\n \'Input Lines\' layer ' + inSLFT + ' is not a lines layer', None, None, None

##        if not desc.FIDSet == '':
##            return False, '\nPlease clear your line selection', None, None


        fldLst = ['FEATSYM', 'AREASYMBOL']
        for eFld in fldLst:
            if eFld not in [str(field.name) for field in desc.fields]:
                return False, '\nThe field ' + eFld + ' is not located in the attribute table for line layer ' + inSLFT.upper(), None, None, None

        areaSymLineLst = list(set([str(row[0]) for row in arcpy.da.SearchCursor(inSLFT, "AREASYMBOL")]))
        if len(areaSymLineLst) > 1:
            return False, '\nThere is more than 1 AREASYMBOL in the '+ inSLFT + ' layer', None, None, None

        localLineSet = set([str(row[0]) for row in arcpy.da.SearchCursor(inSLFT, "FEATSYM")])
        localLineLst = list(localLineSet)

        #ftMsg = ''
        for eVal in localLineLst:

            #if len(eVal) > 0 and len(eVal) != 3:
                #ftMsg = ftMsg +  'WARNING: An unusual FEATSYM has been found in spatial data for ' + os.path.basename(inSLFT.upper()) + '\n'

            if eVal.find(' ') <> -1:
                return False, 'Invalid FEATSYM encountered ' + inSLFT.upper() + '. Check for empty attributes or extra spaces.', None, None, None

        lCount = int(arcpy.GetCount_management(inSLFT).getOutput(0))
        return True, areaSymLineLst, localLineLst, localLineSet, lCount

    except:

        # some type of error, return False

        errorMsg()
        return False, "Unable to validate input points layer", None, None, None




def compLst():

    try:

        pointsLst = spatialPointValidator(inSPFT)[2]
        linesLst = spatialLineValidator(inSLFT)[2]

        comprehensiveLst = pointsLst + linesLst


        return True, comprehensiveLst

    except:

        return False, 'Unable to generate comprehensive (points and lines) special features list'


def txtValidator(txtSPFT):

    totalError = 0

    try:

        areaSymLst = spatialPointValidator(inSPFT)[1]
        with open(txtSPFT, 'r') as chkTXT:
            countLine = 0
            lines = chkTXT.readlines()
            for line in lines:
                countLine = countLine + 1
                lineLst = line.split('|')
                if line.count('"') <> 10:
                    PrintMsg(' \nMissing quotation mark(s) error on line ' + str(countLine) + ' in ' + txtSPFT, 2)
                    totalError = totalError + 1
                elif '   ' in line:
                    PrintMsg(' \nFound multiple space error on line ' + str(countLine) + ' in ' + txtSPFT, 2)
                    totalError = totalError + 1
                elif line[1:6] not in areaSymLst:
                    PrintMsg(' \nAREASYMBOL not found in spatial data, line ' + str(countLine) + ' in ' + txtSPFT, 2)
                    totalError = totalError + 1
                elif len(lineLst) <> 6:
                    PrintMsg( '\nMissing element or pipe on line ' + str(countLine) + ' in ' + txtSPFT, 2)
                    totalError = totalError + 1
                elif len(lineLst[0]) <> 7:
                    PrintMsg( '\nIncorrect length for AREASYMBOL on line ' + str(countLine) + ' in ' + txtSPFT, 2)
                    totalError = totalError + 1
                #ADHOC FEATSYM are not necessarily 3 characters
                #elif len(lineLst[2]) != 5:
                    #PrintMsg( '\nIncorrect length for FEATSYM on line ' + str(countLine) + ' in ' + txtSPFT, 1)


        chkTXT.close()

        if totalError == 0:
            return True,  'Existing special features text file has been validated'
        else:
            return False, 'There was a formatting problem with the existing special features file: ' + txtSPFT

    except:

        # some type of error, return False
        errorMsg()
        return False, 'Unable to validate existing special feature'


def txtLst(txtSPFT):


    try:

        txtSPFTLst = []
        with open(txtSPFT, 'r') as chkTXT:
            lines = chkTXT.readlines()
            for line in lines:
                pipeOne = line.find('|')
                pipeTwo = line.find('|', pipeOne + 1)
                pipeThree = line.find('|', pipeTwo + 1)
                tStr = line[pipeTwo + 2:pipeThree - 1]
                #arcpy.AddMessage(tStr)

                txtSPFTLst.append(tStr)
        chkTXT.close()

        txtSPFTSet = set(txtSPFTLst)

        #arcpy.AddMessage(txtSPFTSet)

        return True,txtSPFTLst, txtSPFTSet

    except:

        # some type of error, return False
        errorMsg()
        return False, 'Unable to prepare ' + txtSPFT + ' for manipulations', None



def crossCheck(txtSPFT):

    try:

        #get the comprehensive set of all special features in the point and line spatial layers
        comprehensiveSet = set(compLst()[1])

        #get the set of features identified in the existing special points text file
        txtSet = set(txtLst(txtSPFT)[1])

        #new set with existing spatial features but no counter part in the existing text
        spatialVoid = comprehensiveSet.difference(txtSet)

        #new set with features identified in the text file but have no spatial features digitized
        txtVoid = txtSet.difference(comprehensiveSet)

        return True, spatialVoid, txtVoid

    except:

         # some type of error, return False
        errorMsg()
        return False, 'Unable to execute crossCheck ', None



def sfDict():

    try:

        spfeatD = {'BLO':('Blowout','A saucer-, cup-, or trough-shaped depression formed by wind erosion on a pre-existing dune or other sand deposit, especially in an area of shifting sand or loose soil or where protective vegetation is disturbed or destroyed. The adjoining accumulation of sand derived from the depression, where recognizable, is commonly included. Blowouts are commonly small.  Typically__to__acres.'),
            'BPI':('Borrow pit','An open excavation from which soil and underlying material have been removed, usually for construction purposes.  Typically__to__acres.'),
            'CLA':('Clay spot','A spot where the surface texture is silty clay or clay in areas where the surface layer of the soils in the surrounding map unit is sandyloam, loam, silt loam, or coarser.  Typically__to__acres.'),
            'DEP':('Depression, closed','A shallow, saucer-shaped area that is slightly lower on the landscape than the surrounding area and that does not have a natural outlet for surface drainage. Typically__to__acres.'),
            'ESB':('Escarpment, bedrock','A relatively continuous and steep slope or cliff, produced by erosion or faulting, that breaks the general continuity of more gently sloping land surfaces. Exposed material is hard or soft bedrock.'),
            'ESO':('Escarpment, nonbedrock','A relatively continuous and steep slope or cliff, which generally is produced by erosion but can be produced by faulting, that breaks the continuity of more gently sloping land surfaces.  Exposed earthy material is nonsoil or very shallow soil.'),
            'GPI':('Gravel pit','An open excavation from which soil and underlying material have been removed and used, without crushing, as a source of sand or gravel.  Typically__to__acres.'),
            'GRA':('Gravelly spot','A spot where the surface layer has more than 35 percent, by volume, rock fragments that are mostly less than 3 inches in diameter in an area that has less than 15 percent rock fragments.  Typically__to__acres.'),
            'GUL':('Gully','A small, steep-sided channel caused by erosion and cut in unconsolidated materials by concentrated but intermittent flow of water.  The distinction between a gully and a rill is one of depth. A gully generally is an obstacle to farm machinery and is too deep to be obliterated by ordinary tillage whereas a rill is of lesser depth and can be smoothed over by ordinary tillage.'),
            'LDF':('Landfill','An area of accumulated waste products of human habitation, either above or below natural ground level. Typically__to__acres.'),
            'LAV':('Lava flow','A solidified, commonly lobate body of rock formed through lateral, surface outpouring of molten lava from a vent or fissure.  Typically__to__acres.'),
            'LVS':('Levee','An embankment that confines or controls water, especially one built along the banks of a river to prevent overflow onto lowlands.'),
            'MAR':('Marsh or swamp','A water saturated, very poorly drained area that is intermittently or permanently covered by water. Sedges, cattails, and rushes are the dominate vegetation in marshes, and trees or shrubs are the dominant vegetation in swamps. Not used in map units where the named soils are poorly drained or very poorly drained. Typically__to__acres.'),
            'MPI':('Mine or quarry','An open excavation from which soil and underlying material have been removed and in which bedrock is exposed. Also denotes surface openings to underground mines. Typically__to__acres.'),
            'MIS':('Miscellaneous water','Small, constructed bodies of water that are used for industrial, sanitary, or mining applications and that contain water most of the year. Typically__to__acres.'),
            'WAT':('Perennial water','Small, natural or constructed lakes, ponds, or pits that contain water most of the year. Typically__to__acres.'),
            'ROC':('Rock outcrop','An exposure of bedrock at the surface of the earth. Not used where the named soils of the surrounding map unit are shallow overbedrock or where "Rock outcrop" is a named component of the map unit. Typically__to__acres.'),
            'SAL':('Saline spot','An area where the surface layer has an electrical conductivity of 8 mmhos/cm more than the surface layer of the named soils in the surrounding map unit. The surface layer of the surrounding soils has an electrical conductivity of 2 mmhos/cm or less.Typically__to__acres.'),
            'SAN':('Sandy spot','A spot where the surface layer is loamy fine sand or coarser in areas where the surface layer of the named soils in the surrounding map unit is very fine sandy loam or finer. Typically__to__acres.'),
            'ERO':('Severely eroded spot','An area where, on the average, 75 percent or more of the original surface layer has been lost because of accelerated erosion.  Not used in map units in which "severely eroded", "very severely eroded", or "gullied" is part of the map unit name.  Typically__to__acres.'),
            'SLP':('Short, steep slope','A narrow area of soil having slopes that are at least two slope classes steeper than the slope class of the surrounding map unit.'),
            'SNK':('Sinkhole','A closed, circular or elliptical depression, commonly funnel shaped, characterized by subsurface drainage and formed either by dissolution of the surface of underlying bedrock (e.g., limestone, gypsum, or salt) or by collapse of underlying caves within bedrock. Complexes of sinkholes in carbonate-rock terrain are the main components of karst topography. Typically__to__acres.'),
            'SLI':('Slide or slip','A prominent landform scar or ridge caused by fairly recent mass movement or descent of earthy material resulting from failure of earth or rock under shear stress along one or several surfaces. Typically__to__acres.'),
            'SOD':('Sodic spot','An area where the surface layer has a sodium adsorption ratio that is at least 10 more than that of the surface layer of the named soils in the surrounding map unit. The surface layer of the surrounding soils has a sodium adsorption ratio of 5 or less.  Typically__to__acres.'),
            'SPO':('Spoil area','A pile of earthy materials, either smoothed or uneven, resulting from human activity. Typically__to__acres.'),
            'STN':('Stony spot','A spot where 0.01 to 0.1 percent of the soil surface is covered by rock fragments that are more than 10 inches in diameter in areas where the surrounding soil has no surface stones.  Typically__to__acres.'),
            'STV':('Very stony spot','A spot where 0.1 to 3.0 percent of the soil surface is covered by rock fragments that are more than 10 inches in diameter in areas where the surface of the surrounding soil is covered by less than 0.01 percent stones. Typically__to__acres.'),
            'WET':('Wet spot','A somewhat poorly drained to very poorly drained area that is at least two drainage classes wetter than the named soils in the surrounding map unit. Typically__to__ acres.')}

        return True, spfeatD

    except:

         # some type of error, return False
        errorMsg()
        return False, 'Unable to gerenate SOI37A dictionary'



def fileUpdater(txtSPFT):

    import bisect

    try:

        #get the generic dictionary SOI 37A
        spfeatD = sfDict()[1]


        #get the results from cross check to find out if there needs to be any additions/deletion
        outPath = spatialPointValidator(inSPFT)[4]
        areaSymLst = spatialPointValidator(inSPFT)[1]
        spatialVoidLst = list(crossCheck(txtSPFT)[1])
        txtVoid = (crossCheck(txtSPFT)[2])
        spatialVoidLst.sort()



        #create a list of the existing points from the special points text file to house the existing points and find entries in
        #the existing special points text file that do not exist spatiallly and get rid of them.
        existsLst = []
        with open(txtSPFT, 'r') as f:
            for line in f.readlines():
                        first = line.find('|')
                        second = line.find('|', first + 1)
                        third = line.find('|', second + 1)
                        fourth = line.find('|', third + 1)
                        fifth = line.find('|', fourth + 1)
                        existsLst.append(line[0:first] + line[second:fifth])
        f.close()

        existsLst.sort()

        noPtLst = []
        for eVal in txtVoid:
            for i in existsLst:
                if i[9:12].upper() == eVal.upper():
                    noPtLst.append(i[9:12].upper())
                    existsLst.remove(i)
                    #arcpy.AddWarning('\n\nThe feature ' + eVal + ' was found in the existing special points text file.  No corresponding features were found in the spatial data.\nThis feature WILL NOT be included in the output.\n\n')


        #create a list for the spatial points that are not identified in the existing special features text (spatialVoidLst) and format the items to match tmpLst (no SPATIALVER and FEATKEY)
        withDefLst = []
        noDefLst =[]
        updateLst = []

        for eVal in spatialVoidLst:
            updateTxt = '"' + areaSymLst[0] + '"|"' + eVal + '"|'
            if eVal in spfeatD:
                featName = spfeatD.get(eVal)[0]
                featDesc = spfeatD.get(eVal)[1]
                updateTxt = updateTxt + '"'+ featName + '"|"' + featDesc + '"'
                withDefLst.append(eVal)
                #arcpy.AddWarning('\n\nThe feature ' + eVal + ' was found in the spatial data but WAS NOT found in the existing special features text file.\nA generic definition was added from SOI-37A. Please review and edit accordingly.\n\n')
            else:
                noDefLst.append(eVal)
                updateTxt = updateTxt + '"FEATNAME"|"FEATDESC"'
                #arcpy.AddWarning('\n\nThe feature ' + eVal + ' was found in the spatial data but WAS NOT found in the existing special features text file.\nThere is no corresponding entry on the SOI37A.\nA "FEATNAME" and "FEATDESC" placeholder was added. Please review and edit accordingly.\n\n')

            updateLst.append(updateTxt)

        #evaluate the new existsLst to find out where items from the updateLst need to be placed in order to make it alphabetically correct
        for lVal in updateLst:
                i = bisect.bisect_right(existsLst, lVal)
                existsLst.insert(i, lVal)

        #change directory to the location of the existing special points text file to save a new feature.txt file to
        #os.chdir(os.path.dirname(txtSPFT))

        outLoc = outPath + os.sep

        #create the new 'features.txt' file
        #PrintMsg(' \nCreating the file ' + outLoc.upper()  + 'FEATURES.TXT\n', 1)
        with open(outLoc + 'feature', 'w') as f:
            for eItem in existsLst:
                f.write(eItem + '\n')
        f.close()

        return True, noPtLst, withDefLst, noDefLst

    except:

        # some type of error, return False
        errorMsg()
        return False, 'Unable to create features.txt from the existing special points file', None, None



def fileGenerator():

    try:

        areaSymLst = spatialPointValidator(inSPFT)[1]
        outPath = spatialPointValidator(inSPFT)[4]

        #get the generic dictionary SOI 37A
        spfeatD = sfDict()[1]

        #get the list of all the specialfeatures
        getCompLst = compLst()[1]
        #arcpy.AddMessage(getCompLst)
        getCompLst.sort()

        containerLst = []
        withDefLst = []


        for eVal in getCompLst:
            updateTxt = '"' + areaSymLst[0] + '"|"' + eVal + '"|'
            if eVal in spfeatD:
                #add the SOI 37A generic descriptions if available
                withDefLst.append(eVal)
                updateDesc = spfeatD.get(eVal)
                featName = updateDesc[0]
                featDesc = updateDesc[1]
                updateTxt = updateTxt + '"'+ featName + '"|"' + featDesc + '"'
            else:
                #add place holders that need updating
                updateTxt = updateTxt + '"FEATNAME"|"FEATDESC"'

            containerLst.append(updateTxt)

        containerLst.sort()

        #write the file from the list
        outLoc = outPath + os.sep + 'feature'

        with open(outLoc, 'w') as f:
            for eVal in containerLst:
                f.write(eVal + '\n')
        f.close()

        return True, withDefLst

    except:

        # some type of error, return False

        errorMsg()
        return False, 'Unable to generate a new features.txt file'

#===============================================================================


import sys, os, arcpy, time, getpass, fnmatch, traceback



#Parameters
inSpatialDir = sys.argv[1]
ssaSym = sys.argv[2]
inTxtDir = sys.argv[3]

PrintMsg(' \n \n ')
sep = '-'*100

try:

    with open(inSpatialDir + os.sep + 'QA_Special_Features_Report.txt', 'w') as f:
        start = time.strftime("%a, %d %b %Y %H:%M:%S")
        f.write("\n################################################################################################################\n")
        f.write('Executing \"Generate Special Features\" tool\n')
        f.write('User Name: ' + getpass.getuser() + '\n')
        f.write('Date Executed: ' + start + '\n')
        f.write('User Parameters:\n')
        f.write('\tInput folder containing spatial data: ' + inSpatialDir + '\n')
        f.write('\tInput folder containing existing feature files: ' + inTxtDir + '\n')
        f.write("################################################################################################################\n\n")
    f.close()

    qaDict = {}
    txtDict = {}
    targetLst =[]


    #accumulate the file paths of all point nad line special features contained in the user defined root dir
    #it is targeting the line special features, if it doesn't find one, it won't try to find the points
    #if a line is found and no corresponding point is found, the arcpy describre object in spatialPointValidator throws an error

    paramSSA = str(arcpy.GetParameterAsText(1))
    paramLst = list(paramSSA.split(';'))
    paramLst.sort()
    arcpy.SetProgressor('step', 'Creating Archives...', 0, len(paramLst), 1)
    for eSSA in paramLst:
        targetLst.append(str(arcpy.GetParameterAsText(0).strip(';')) + os.sep + eSSA + os.sep + eSSA + '_l.shp')


    for target in targetLst:
        keyName = os.path.basename(target)[:5].lower()
        parDir = os.path.dirname(target)
        pFile = parDir + os.sep + keyName + '_p.shp'





      # this block was used for standard SSURGO downloaded file names
##    for dirpath, dirnames, filenames in os.walk(inSpatialDir):
##         for filename in filenames:
##             inFile = os.path.join(dirpath, filename)
##             if fnmatch.fnmatch(inFile, '*soilsf_l_*.shp'):
##                 keyName = os.path.basename(inFile)[9:14]
##                 parDir = os.path.dirname(inFile)
##                 pFile = parDir + os.sep + 'soilsf_p_' + keyName + '.shp'


##

        if keyName not in qaDict:
            qaDict[keyName] = [target, pFile]

    if len(qaDict) == 0:
        errMsg = 'Unable to find any qualifying line and special features in ' + inSpatialDir.upper()
        with open(inSpatialDir + os.sep + 'QA_Special_Features_Report.txt', 'a') as f:
            f.write('\n\n' + errMsg + '\n A special feature line file is required even if there are no features')
        f.close()
        PrintMsg(errMsg, 2)
        #raise MyError

    else:

         #accumulate the file paths of all point nad line special features contained in the user defined root dir
        for dirpath, dirnames, filenames in os.walk(inTxtDir):
            for filename in filenames:
                tFile = os.path.join(dirpath, filename)

                if fnmatch.fnmatch(tFile, '*soilsf_t_*.txt'):
                    keyName = os.path.basename(tFile)[9:14]
                    if keyName not in txtDict:
                        txtDict[keyName] = [tFile]


        #merege the qaDict and txtDict, if a corresponding text file is found
        compDict = {}
        for eKey in qaDict:
            if eKey in txtDict:
                compDict[eKey] = qaDict[eKey] + txtDict[eKey]
            else: compDict[eKey] = qaDict[eKey]



        #set the parameters
        for eKey in sorted(compDict.iterkeys()):
            arcpy.SetProgressorLabel('Processing for: ' + eKey)
            arcpy.SetProgressorPosition()
            valLst = compDict.get(eKey)
            inSPFT = valLst[1]
            inSLFT = valLst[0]
            if len(valLst) == 3:
                txtSPFT = valLst[2]



            with open(inSpatialDir + os.sep + 'QA_Special_Features_Report.txt', 'a') as f:
                f.write('\n\n\nProcessing special features for: ' + os.path.basename(inSLFT)[:5].upper() + '\n')
                f.write(sep +'\n')

            f.close()

            #Functions
            #return True, areaSymLst, localPointsLst, localPointsSet, desc.path, pCount
            pValid, SPFT2, SPFT3, SPFT4, SPFT5, SPFT6 = spatialPointValidator(inSPFT)
            if pValid:

                #PrintMsg('Input points layer ' + inSPFT.upper() + ' has been validated', 1)
                with open(inSpatialDir + os.sep + 'QA_Special_Features_Report.txt', 'a') as f:
                    f.write('\tSpecial Feature Point Count: ' + str(SPFT6) + '\n')
                    #pLen = len(SPFT3)
                    #f.write('\tSpecial Feature Point: ' + '\n')
                    for p in SPFT3:
                        f.write('\t\t'+ p + '\n')
                f.close()

            else:
                pass
                #raise MyError, SPFT2


            #return True, areaSymLineLst, localLineLst, localLineSet, lCount
            lValid, SLFT2, SLFT3, SLFT4, SLFT5 = spatialLineValidator(inSLFT)
            if lValid:

                with open(inSpatialDir + os.sep + 'QA_Special_Features_Report.txt', 'a') as f:
                    f.write('\tSpecial Feature Line Count: ' + str(SLFT5) + '\n')
                    #lLen = len(SLFT3)
                    #f.write('\tSpecial Feature Line: ' + '\n')
                    for p in SLFT3:
                        f.write('\t\t'+ p + '\n')
                f.close()

            else:
                pass
                #raise MyError, SLFT2



            if len(valLst) == 3:

                tValid, tV1 = txtValidator(txtSPFT)
                if tValid:

                    pass
                else:
                    pass
                    #raise MyError, tV1



                ccValid, cc1 = sfDict()
                if ccValid:

                   pass

                else:

                    raise MyError, cc1


                #return True, noPtLst, withDefLst, noDefLst
                fuValid, fU1, fU2, fU3 = fileUpdater(txtSPFT)
                if fuValid:

                    with open(inSpatialDir + os.sep + 'QA_Special_Features_Report.txt', 'a') as f:
                        f.write('\tMessages:\n')
                        outSSAPath = spatialPointValidator(inSPFT)[4]
                        ftCnt = SPFT6 + SLFT5
                        if ftCnt == 0:
                            cntMsg = 'No special feature points or lines found in ' + os.path.basename(inSPFT)[:5] + '.  An empty feature file is still being generated.'
                            f.write('\t\t' + cntMsg)
                            PrintMsg(cntMsg, 1)

                        #for no errors = exact match between spatial features and existing special features text file (soilsf_t_xx000.txt)
                        if len(fU1) + len(fU2) + len(fU3) == 0: #and SPFT7 <> '' and SLFT6 <> '':
                            f.write('\t\tNONE\n')

                        else:

                            if len(fU1) > 0:
                                noPtMsg = ','.join(fU1) + ' were found in the existing ' + os.path.basename(txtSPFT) + ' file.  No points matching points were found in the spatial data. They will be omitted from the output feature file.'
                                PrintMsg(noPtMsg, 1)
                                f.write('\t\t' + noPtMsg + '\n')
                            if len(fU2) > 0:
                                withDefMsg = ','.join(fU2) + ' were found in the spatial data but not in the ' + os.path.basename(txtSPFT) + ' file.  A generic definition has been added for these features. MANUAL EDITS LIKELY.'
                                PrintMsg(withDefMsg, 1)
                                f.write('\t\t' + withDefMsg + '\n')
                            if len(fU3) > 0:
                                noDefMsg = ','.join(fU3) + ' were found in the spatial data but not in the ' + os.path.basename(txtSPFT) + ' file.  A FEATNAME and FEATDESC place holder was added. MANUAL EDITS REQUIRED.'
                                PrintMsg(noDefMsg, 1)
                                f.write('\t\t' + noDefMsg + '\n')

                            #if SPFT7 <> '':
                                #PrintMsg(SPFT7, 1)
                                #f.write('\t\t' + SPFT7)
                            #if SLFT6 <> '':
                                #PrintMsg(SLFT6, 1)
                                #f.write('\t\t' + SPFT7)

                        f.write('\n\n')
                    f.close()

                    PrintMsg('Successfully generated the feature file using the ' + os.path.basename(txtSPFT) + ' feature file. \n ', 0 )

                else:
                    pass
                    #raise MyError, fU1


            else:


                fgValid, fG1 = fileGenerator()
                if fgValid:
                    with open(inSpatialDir + os.sep + 'QA_SPECIAL_FEATURES_REPORT.txt', 'a') as f:
                        outSSAPath = spatialPointValidator(inSPFT)[4]
                        f.write('\tMessages:\n')
                        ftCnt = SPFT6 + SLFT5
                        if ftCnt == 0:
                            cntMsg = 'No special feature points or lines found in ' + os.path.basename(inSPFT)[:5] + '.  An empty feature file is still being generated.'
                            f.write('\t\t' + cntMsg)
                            PrintMsg(cntMsg, 1)
                        fgMsg = '\t\tSuccessfully generated the features.txt for ' + os.path.basename(inSPFT)[:5] + ' using generic feature definitions if available. \n '
                        f.write(fgMsg)
                        #if SPFT7 <> '':
                            #f.write('\t\t' + SPFT7)
                        #if SLFT6 <> '':
                            #f.write('\t\t' + SPFT7)
                        f.write('\n\n')
                    f.close()
                    PrintMsg('Successfully generated the feature file for '+ os.path.basename(inSPFT)[:5] + ' using generic feature definitions if available. MANUAL EDITS LIKELY. \n ', 1)

                else:

                    raise MyError, fG1


        PrintMsg(' \n \n A report titled: QA_Special_Features_Report.txt has been added to ' + inSpatialDir.upper()  + ' \n \n ')


except MyError, e:
        PrintMsg(str(e) + " \n", 2)

except:
    errorMsg()

