import arcpy
from arcpy import env
import os, sys, traceback

class ToolValidator(object):
  """Class for validating a tool's parameter values and controlling
  the behavior of the tool's dialog."""

  def __init__(self):
    """Setup arcpy and the list of tool parameters."""
    self.params = arcpy.GetParameterInfo()

  def initializeParameters(self):
    """Refine the properties of a tool's parameters.  This method is
    called when the tool is opened."""
    self.params[3].category = "Advanced"
    self.params[3].enabled = True
    return

  def updateParameters(self):
    """Modify the values and properties of parameters before internal
    validation is performed.  This method is called whenever a parameter
    has been changed."""

    try:
      # Handle choice list according to the first two parameter values
        clearChoices = False
        refreshChoices = False

        if self.params[0].value is None:
            clearChoices = True
            refreshChoices = False

        else:
            # param 1 has just been changed to a new value
            if  self.params[0].altered and not self.params[0].hasBeenValidated:
                clearChoices = True
                refreshChoices = True

        if clearChoices:
            # Clear the choice list
            self.params[2].filter.list = []
            self.params[2].values = []

        if refreshChoices:
            # Clear the choice list and create a new one
            self.params[2].filter.list = []
            self.params[2].values = []

        # get list of unique areasymbol values from survey boundary layer (param 1)
        hasAreasymbol = False
        env.workspace = self.params[0].value
        fcList = arcpy.ListFeatureClasses("SAPOLYGON", "Polygon")
        valList = list()
        badList = list()

        if len(fcList) > 0:

            for fc in fcList:
                hasMusym = False
                desc = arcpy.Describe(fc)
                fcName = desc.name  # name of polygon featureclass
                flds = desc.fields  # list of field objects

              # Ignore _QA feature classes
                if len(valList) == 0 and fcName[:3] != "QA_":
                    fldNames = list()  # this list of field names will be used to identify the target featureclasses

                # create list of field names
                for fld in flds:
                    fldNames.append(fld.baseName.upper())

                if not ("MUKEY" in fldNames or "FEATSYM" in fldNames or "MUSYM" in fldNames) and "AREASYMBOL" in fldNames:

                  # This should be the Survey Boundary featureclass, use it to get list of surveys
                  for fld in flds:

                    if fld.baseName.upper() == "AREASYMBOL":
                      # Open a search cursor on the featureclass and find any blank or NULL polygons
                      # values in this featureclass are populated. Should we do this for every featureclass?

                      fldList = [fld.name, "OID@"]
                      # use cursor to generate list of values
                      with arcpy.da.SearchCursor(os.path.join(env.workspace,fc), fldList) as srcCursor:
                            for row in srcCursor:

                                if row[0] is not None:

                                    if not row[0] in valList:
                                        if len(str(row[0])) == 5 and row[0] == row[0].strip() and row[0].strip() != "" and row[0].strip() != " ":
                                            valList.append(row[0])
                                        else:
                                            badList.append(str(row[1]))

                                else:
                    			    badList.append(str(row[1]))
                      break

        if len(badList) > 1:
	       self.params[3].value = "The following OID records in SAPOLYGON have errors: "+ ",".join(badList)

        elif len(valList) == 1:
          self.params[2].filter.list = valList
          self.params[2].values = valList[0]  # since there's only one choice, check the box

        elif len(valList) > 1:
            valList.sort()
            self.params[2].filter.list = valList
            self.params[2].values = []  # multiple choices, clear the checkboxes

        else:
          pass

        return

    except:
      tb = sys.exc_info()[2]
      tbinfo = traceback.format_tb(tb)[0]
      self.params[0].value = tbinfo + " \n" + str(sys.exc_type) + ": " + str(sys.exc_value)
      return

  def updateMessages(self):
    """Modify the messages created by internal validation for each tool
    parameter.  This method is called after internal validation."""

    try:

	# If there were bad areasymbol values, throw an error to the first parameter.  Tried assigning the 3rd paramater
        # the error but it didn't take.
        if str(self.params[3].value).find("The following OID records") > -1:
            self.params[0].setErrorMessage(self.params[3].value)
            #self.params[0].setErrorMessage("AREASYMBOL Error for the following OID record(s)")

        if self.params[0].value and not self.params[3].value:
            env.workspace = self.params[0].value
            fcList = arcpy.ListFeatureClasses("SAPOLYGON", "Polygon")

            if len(fcList) == 0:
                self.params[0].setErrorMessage("SAPOLYGON layer is missing from RTSD Feature Dataset")

            sapolyFC = os.path.join(env.workspace,"SAPOLYGON")
            if len([field for field in arcpy.ListFields(sapolyFC,"AREASYMBOL")]) == 0:
                self.params[0].setErrorMessage("SAPOLYGON layer is missing AREASYMBOL fileld")

            for fld in self.params[2].filter.list:
                if fld.find(' ') > -1:
                    self.params[2].setErrorMessage("Error in AREASYMBOL value(s) in SAPOLYGON layer")

                if not len(fld) == 5:
                    self.params[2].setErrorMessage("AREASYMBOL Value(s) Error! All Areasymbols must be 5 digits")

        return

    except:
      tb = sys.exc_info()[2]
      tbinfo = traceback.format_tb(tb)[0]
      self.params[0].value = tbinfo + " \n" + str(sys.exc_type) + ": " + str(sys.exc_value)
      return
