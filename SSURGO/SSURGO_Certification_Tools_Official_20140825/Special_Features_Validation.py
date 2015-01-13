import sys, os, fnmatch, traceback, arcpy
from arcpy import env

class ToolValidator(object):
  """Class for validating a tool's parameter values and controlling
  the behavior of the tool's dialog."""

  def __init__(self):
    """Setup arcpy and the list of tool parameters."""
    self.params = arcpy.GetParameterInfo()

  def initializeParameters(self):
    """Refine the properties of a tool's parameters.  This method is
    called when the tool is opened."""
    return

  def updateParameters(self):
    """Modify the values and properties of parameters before internal
    validation is performed.  This method is called whenever a parameter
    has been changed."""
    try:

        if self.params[0].value and not self.params[0].hasBeenValidated:
            # clear the other parameters upon change of input layer
                self.params[1].value = ""

        rootDir = str(self.params[0].value)
        if os.path.isdir(rootDir) and rootDir.find('gdb') == -1 :
            #self.params[2].enabled = True
            #self.params[3].enabled = False

            valLst = []

            rootLst = os.listdir(rootDir)
            for e in rootLst:
                if os.path.isdir(rootDir + os.sep + e) and len(e) == 5:
                    if os.path.isdir(rootDir + os.sep + e) and len(e) == 5:
                        arcpy.env.workspace = (rootDir + os.sep + e)
                        fLst = arcpy.ListFeatureClasses()
                        fStr = str(fLst)
                        if fStr.find('_a.shp') <> -1 and fStr.find('_b.shp') <> -1\
                            and fStr.find('_c.shp') <> -1 and fStr.find('_d.shp') <> -1\
                            and fStr.find('_l.shp') <> -1 and fStr.find('_p.shp') <> -1:
                            if not e.upper() in valLst:
                                valLst.append(e)

                valLst.sort()
                self.params[1].filter.list = valLst


    except:
        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        #self.params[2].value = tbinfo + " \n" + str(sys.exc_type) + ": " + str(sys.exc_value)
        #self.params[4].value = "_".join(valList)
        return

  def updateMessages(self):
    """Modify the messages created by internal validation for each tool
    parameter.  This method is called after internal validation."""
    self.params[0].clearMessage()
    self.params[1].clearMessage()
    if len(self.params[1].filter.list) == 0:
        self.params[0].setErrorMessage('Unable to locate any valid SSURGO Export folders')

    self.params[2].clearMessage()

    if self.params[2].value:

        ftWS = ['DEFOLDER', 'DEWORKSPACE']
        ftSrc = str(self.params[2].value)
        desc = arcpy.Describe(ftSrc)
        ftType = desc.dataElementType.upper()
        if ftType in ftWS:
            if ftType == 'DEWORKSPACE':
                wsType = 'ESRIDATASOURCESGDB.FILEGDBWORKSPACEFACTORY.1'
                if not desc.workspaceFactoryProgID.upper() == wsType:
                    self.params[2].setErrorMessage('Incorrect type of workspace.  Must be a Folder or File Geodatabase')

                elif not arcpy.Exists(ftSrc + os.sep + 'featdesc'):
                    self.params[2].setErrorMessage('Unable to find the featdesc as a root table in the geodatabase ' + ftSrc)

            elif ftType == 'DEFOLDER':
                sfTxtLst= list()
                for dirpath, dirnames, filenames in os.walk(ftSrc):
                    for filename in filenames:
                        a = os.path.join(dirpath, filename)
                        if fnmatch.fnmatch(a, '*soilsf_t_*.txt'):
                            sfTxtLst.append(a)
                        if len(sfTxtLst) == 0:
                            self.params[2].setErrorMessage('No speacial features text files were found in this location')

        else:
            self.params[2].setErrorMessage('Incorrect type of workspace.  Must be a Folder or File Geodatabase')



    return
