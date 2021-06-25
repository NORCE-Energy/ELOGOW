# ELOGOW
This repository contains the first version of a modelica model that has been used for a conference paper in 14th modelica conference

## Setup
Before your run the model, edit the path in the package ELOGOW to use the data used for the simulation. 

``` package ELOGOW
  // CP: 65001
  // SimulationX Version: 4.2.2.68604
  import SI = Modelica.SIunits;
  constant String files = Modelica.Utilities.Files.loadResource("put the path here \\ELOGOW\\src\\modelica\\Models\\data\\");
```
