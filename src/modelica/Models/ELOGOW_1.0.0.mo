package ELOGOW
  // CP: 65001
  // SimulationX Version: 4.2.2.68604
  import SI = Modelica.SIunits;
  constant String files = Modelica.Utilities.Files.loadResource("modelica://ELOGOW/data/");

  package Batteries
    block LB
      import Modelica.Math.Vectors;
      parameter Real CR = 1.0 "Charing rate";
      parameter Real DR = 1.0 "Discharging rate";
      parameter Real MaxEnergy(unit = "Wh") = 30.0;
      parameter Real InitialCharge = 0.0 "% of MaxEnergy";
      constant Real WH_TO_J = 3.6e+3;
      Real EMax(unit = "Joules") = MaxEnergy * WH_TO_J;
      Real InletCableMax = CR * EMax / 3600;
      Real OutletCableMax = DR * EMax / 3600;
      Interfaces.PConnection Inlet annotation(
        Placement(visible = true, transformation(origin = {-74, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 20}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
      Interfaces.CP Ci annotation(
        Placement(visible = true, transformation(origin = {-72, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Interfaces.Energy E annotation(
        Placement(visible = true, transformation(origin = {72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {59, -59}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Interfaces.PConnection Outlet annotation(
        Placement(visible = true, transformation(origin = {-70, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-79, -61}, extent = {{-21, -21}, {21, 21}}, rotation = 180)));
      Interfaces.CP Co annotation(
        Placement(visible = true, transformation(origin = {-72, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SI.Power Losses;
      Real OutletLimit;
      Real effOutlet;
      Real lossFactor;
    initial equation
      E.E = EMax * InitialCharge * 1e-2;
    equation
      der(E.E) = Inlet.P - Outlet.P - Losses;
//InletLimit=effInlet*InletCableMax;
      OutletLimit = effOutlet * OutletCableMax;
      Inlet.P = Ci * InletCableMax;
      Outlet.P = Co * OutletLimit;
      Losses = lossFactor * Inlet.P;
      effOutlet = 1 / (1 + exp(-100 * (E.E / EMax - 0.1)));
      lossFactor = 1 / (1 + exp(-100 * (E.E / EMax - 0.95)));
      annotation(
        Icon(graphics = {Rectangle(origin = {24, 40}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-56, 18}, {4, -18}}), Rectangle(origin = {-19, 2}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-13, 20}, {47, -102}}), Polygon(origin = {8, -32}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{2, 38}, {-22, 4}, {-8, 4}, {-24, -26}, {6, 8}, {-8, 8}, {-8, 8}, {2, 38}}), Rectangle(origin = {-3, 66}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-9, 6}, {11, -8}}), Text(origin = {-9, 86}, extent = {{25, -8}, {-15, 8}}, textString = "%name")}));
    end LB;
    annotation(
      Icon(graphics = {Rectangle(origin = {-19, 2}, fillColor = {67, 67, 67}, fillPattern = FillPattern.Solid, extent = {{-21, 20}, {59, -60}}), Rectangle(origin = {-1, 68}, fillColor = {176, 176, 176}, fillPattern = FillPattern.Solid, extent = {{-9, 6}, {11, -8}}), Rectangle(origin = {0, 40}, fillColor = {181, 181, 181}, fillPattern = FillPattern.Solid, extent = {{-40, 20}, {40, -20}}), Polygon(origin = {6, -2}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{6, 48}, {-22, 4}, {-8, 4}, {-28, -34}, {6, 8}, {-8, 8}, {-8, 8}, {6, 48}})}));
  end Batteries;

  package Interfaces
    connector Energy
      SI.Energy E;
      annotation(
        Icon(graphics = {Ellipse(origin = {-8, -45}, rotation = 90, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, lineThickness = 1, extent = {{-12, -17}, {76, -1}}, endAngle = 360), Text(origin = {-49, 111}, extent = {{99, -65}, {-5, 3}}, textString = "%name"), Ellipse(origin = {0, -17}, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, lineThickness = 1, extent = {{-40, -5}, {44, 9}}, endAngle = 360), Ellipse(origin = {42, 21}, rotation = 90, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, lineThickness = 1, extent = {{-72, 3}, {4, 77}}, endAngle = 360), Rectangle(origin = {69, -10}, extent = {{-15, 14}, {15, -14}})}, coordinateSystem(initialScale = 0.1)),
        Diagram(graphics = {Rectangle(origin = {69, -10}, extent = {{-15, 14}, {15, -14}}), Text(origin = {-49, 111}, extent = {{99, -65}, {-5, 3}}, textString = "%name"), Ellipse(origin = {0, -17}, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, lineThickness = 1, extent = {{-40, -5}, {44, 9}}, endAngle = 360), Ellipse(origin = {42, 21}, rotation = 90, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, lineThickness = 1, extent = {{-72, 3}, {4, 77}}, endAngle = 360), Ellipse(origin = {-8, -45}, rotation = 90, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, lineThickness = 1, extent = {{-12, -17}, {76, -1}}, endAngle = 360)}));
    end Energy;

    connector PConnection
      SI.Power P;
      annotation(
        Icon(graphics = {Line(origin = {-3.87034, -0.19076}, points = {{-53, 0}, {53, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 11), Polygon(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{10, 46}, {-22, 4}, {-8, 4}, {-26, -30}, {6, 8}, {-8, 8}, {-8, 8}, {10, 46}}), Text(origin = {-2.13163e-14, -59}, extent = {{-60, 19}, {60, -19}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
        Diagram(graphics = {Text(origin = {-3, -53}, extent = {{-47, 9}, {47, -9}}, textString = "%name"), Polygon(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{10, 46}, {-22, 4}, {-8, 4}, {-26, -30}, {6, 8}, {-8, 8}, {-8, 8}, {10, 46}}), Line(origin = {-3.87034, -0.19076}, points = {{-53, 0}, {53, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 11)}));
    end PConnection;

    connector CP = input Real "Controlled variable" annotation(
      Icon(graphics = {Text(origin = {-12, 41}, extent = {{-18, 15}, {26, -21}}, textString = "%name"), Polygon(origin = {-2, -2}, rotation = 90, fillColor = {5, 212, 29}, fillPattern = FillPattern.Solid, points = {{-22, 18}, {2, -18}, {22, 18}, {-22, 18}})}, coordinateSystem(initialScale = 0.1)),
      Diagram(graphics = {Text(origin = {-6, 59}, extent = {{-18, 15}, {26, -21}}, textString = "%name"), Polygon(origin = {2, -4}, rotation = 90, fillColor = {5, 212, 29}, fillPattern = FillPattern.Solid, points = {{-22, 18}, {2, -18}, {22, 18}, {-22, 18}})}, coordinateSystem(initialScale = 0.1)));

    connector Wind
      SI.Velocity u;
      annotation(
        Icon(graphics = {Ellipse(origin = {73, 11}, rotation = 180, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-5, 7}, {61, -53}}, endAngle = 360), Rectangle(origin = {46, 32}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-38, 10}, {-4, -28}}), Line(origin = {10.8631, 4.2434}, rotation = 180, points = {{-32, 0}, {32, 0}, {98, 0}}, thickness = 1), Text(origin = {9.0697, -11.0001}, extent = {{-83.0697, 55.0001}, {68.9303, -76.9999}}, textString = "%name"), Line(origin = {24.5288, 3.77885}, points = {{-112, 0}, {76, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open})}, coordinateSystem(initialScale = 0.1)));
    end Wind;
    annotation(
      Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {20, 0}, lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-10, 70}, {10, 70}, {40, 20}, {80, 20}, {80, -20}, {40, -20}, {10, -70}, {-10, -70}, {-10, 70}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(fillColor = {102, 102, 102}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-100, 20}, {-60, 20}, {-30, 70}, {-10, 70}, {-10, -70}, {-30, -70}, {-60, -20}, {-100, -20}, {-100, 20}})}));
  end Interfaces;

  package Sensors
    model EnergySensor
      Modelica.Blocks.Interfaces.RealOutput V annotation(
        Placement(visible = true, transformation(origin = {86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {82, -1.77636e-15}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      ELOGOW.Interfaces.Energy E annotation(
        Placement(visible = true, transformation(origin = {-88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, 2}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
    equation
      V = E.E;
      annotation(
        Icon(graphics = {Ellipse(origin = {16, 12}, lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, extent = {{-12, -12}, {12, 12}}, endAngle = 360), Line(origin = {-2.12388, -14.8673}, points = {{22.9, 32.8}, {40.2, 57.3}}), Ellipse(origin = {16, 12}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-70, -70}, {46, 42}}, endAngle = 360), Ellipse(origin = {2, -2}, fillColor = {64, 64, 64}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, endAngle = 360), Polygon(origin = {16, 12}, rotation = -17.5, fillColor = {64, 64, 64}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-9, -12}, {-2, 30}, {2, 39}, {2, 30}, {-5, -12}, {-9, -12}}), Line(origin = {83.9004, -0.19018}, points = {{-21, 0}, {-15, 0}}, thickness = 1), Text(origin = {6, 74}, extent = {{-42, 12}, {42, -12}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));
    end EnergySensor;

    model PowerSensor
      parameter Real Error = 1.0 "Error factor";
      Modelica.Blocks.Interfaces.RealOutput V annotation(
        Placement(visible = true, transformation(origin = {86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {82, -1.77636e-15}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      ELOGOW.Interfaces.PConnection P annotation(
        Placement(visible = true, transformation(origin = {-88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-63, 1}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
    equation
      V = Error * P.P;
      annotation(
        Icon(graphics = {Text(origin = {6, 74}, extent = {{-42, 12}, {42, -12}}, textString = "%name"), Line(origin = {83.9004, -0.19018}, points = {{-21, 0}, {-15, 0}}, thickness = 1), Ellipse(origin = {16, 12}, fillColor = {103, 103, 103}, fillPattern = FillPattern.Solid, extent = {{-62, -64}, {46, 42}}, endAngle = 360), Polygon(origin = {20, 10}, rotation = -17.5, fillColor = {234, 234, 234}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-9, -12}, {-2, 30}, {2, 39}, {2, 30}, {-5, -12}, {-9, -12}}), Ellipse(origin = {8, 0}, fillColor = {223, 223, 223}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
    end PowerSensor;

    model WindSensor
      ELOGOW.Interfaces.Wind wind annotation(
        Placement(visible = true, transformation(origin = {-64, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-74, -2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput v annotation(
        Placement(visible = true, transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {84, -1.55431e-15}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    equation
      v = wind.u;
      annotation(
        Icon(graphics = {Polygon(origin = {-4, 44}, fillColor = {0, 255, 255}, fillPattern = FillPattern.VerticalCylinder, points = {{54, -14}, {24, -14}, {-48, -14}, {-64, 2}, {-34, 2}, {-10, -10}, {54, -10}, {66, -12}, {54, -14}}), Rectangle(origin = {2, -39}, fillColor = {0, 85, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-20, 41}, {20, -21}}), Rectangle(origin = {2, 0}, fillColor = {0, 170, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-4, 32}, {4, 2}}), Text(origin = {-4, 78}, extent = {{-48, 12}, {48, -16}}, textString = "%name")}));
    end WindSensor;

    model ESensor
      parameter Real MaxEnergy(unit = "Wh", min = 1.0) = 30.0;
      constant Real WH_TO_J = 3.6e+3;
      Modelica.Blocks.Interfaces.RealOutput V annotation(
        Placement(visible = true, transformation(origin = {86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {82, -1.77636e-15}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
      ELOGOW.Interfaces.Energy E annotation(
        Placement(visible = true, transformation(origin = {-88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, 2}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
    equation
      V = 100 * E.E / (MaxEnergy * WH_TO_J);
      annotation(
        Icon(graphics = {Ellipse(origin = {16, 12}, lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, extent = {{-12, -12}, {12, 12}}, endAngle = 360), Line(origin = {-2.12388, -14.8673}, points = {{22.9, 32.8}, {40.2, 57.3}}), Ellipse(origin = {16, 12}, fillColor = {196, 255, 1}, fillPattern = FillPattern.Solid, extent = {{-70, -70}, {46, 42}}, endAngle = 360), Ellipse(origin = {2, -2}, fillColor = {64, 64, 64}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, endAngle = 360), Polygon(origin = {16, 12}, rotation = -17.5, fillColor = {64, 64, 64}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-9, -12}, {-2, 30}, {2, 39}, {2, 30}, {-5, -12}, {-9, -12}}), Line(origin = {83.9004, -0.19018}, points = {{-21, 0}, {-15, 0}}, thickness = 1), Text(origin = {6, 74}, extent = {{-42, 12}, {42, -12}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));
    end ESensor;

    model EmissionSensor
      Modelica.Blocks.Interfaces.RealInput CO2 annotation(
        Placement(visible = true, transformation(origin = {-92, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput CumCO2 annotation(
        Placement(visible = true, transformation(origin = {68, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput CumNOx annotation(
        Placement(visible = true, transformation(origin = {69, -33}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {80, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput NOx annotation(
        Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    equation
      der(CumCO2) = CO2;
      der(CumNOx) = NOx;
      annotation(
        Icon(graphics = {Rectangle(origin = {0.149857, 0.0659377}, extent = {{-60.1499, 59.8613}, {60.1499, -59.8613}}), Text(origin = {0, 30}, extent = {{-20, 10}, {20, -10}}, textString = "CO2"), Text(origin = {0, -30}, extent = {{-20, 10}, {20, -10}}, textString = "NOx"), Line(points = {{-60, 0}, {60, 0}}), Text(origin = {7.10543e-15, 70}, extent = {{-58, 10}, {58, -10}}, textString = "Cumulative")}));
    end EmissionSensor;
    annotation(
      Icon(graphics = {Ellipse(origin = {-21, 24}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, lineThickness = 2, extent = {{-33, 30}, {75, -74}}, endAngle = 360), Line(origin = {10.2036, 12.3274}, points = {{-11, -11}, {25, 27}}, thickness = 2, arrow = {Arrow.None, Arrow.Open}, arrowSize = 6)}));
  end Sensors;

  package Systems
    block WTSys
      parameter Integer tnr = 1 "Number of turbines";
      ELOGOW.WindTurbines.WindTurbine Turbine(tnr = tnr) annotation(
        Placement(visible = true, transformation(origin = {0, -18}, extent = {{-56, -56}, {56, 56}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput ws annotation(
        Placement(visible = true, transformation(origin = {-13, 83}, extent = {{-19, -19}, {19, 19}}, rotation = 90), iconTransformation(origin = {-24, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput pout annotation(
        Placement(visible = true, transformation(origin = {91, 83}, extent = {{-19, -19}, {19, 19}}, rotation = 90), iconTransformation(origin = {16, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      ELOGOW.Interfaces.PConnection Pout annotation(
        Placement(visible = true, transformation(origin = {105, -17}, extent = {{-29, -29}, {29, 29}}, rotation = 0), iconTransformation(origin = {84, 0}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
      ELOGOW.Interfaces.Wind Wind annotation(
        Placement(visible = true, transformation(origin = {-123, 47}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-80, -2}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
      ELOGOW.Sensors.PowerSensor WTPS annotation(
        Placement(visible = true, transformation(origin = {62, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
      ELOGOW.Sensors.WindSensor WSS annotation(
        Placement(visible = true, transformation(origin = {-51, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    equation
      connect(Turbine.Pout, Pout) annotation(
        Line(points = {{47, -18}, {105, -18}, {105, -17}}));
      connect(Wind, Turbine.Wind) annotation(
        Line(points = {{-123, 47}, {-100.5, 47}, {-100.5, -18}, {-45, -18}}));
      connect(WSS.v, ws) annotation(
        Line(points = {{-35, 41}, {-14, 41}, {-14, 66}, {-13, 66}, {-13, 83}}, color = {0, 0, 127}));
      connect(Turbine.Wind, WSS.wind) annotation(
        Line(points = {{-44, -18}, {-65, -18}, {-65, 39}}));
      connect(Turbine.Pout, WTPS.P) annotation(
        Line(points = {{48, -18}, {52, -18}, {52, 40}, {53, 40}}));
      connect(WTPS.V, pout) annotation(
        Line(points = {{73, 40}, {91, 40}, {91, 83}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Rectangle(origin = {26, 49}, extent = {{-86, 51}, {34, -147}}), Text(origin = {-24, 67}, extent = {{-10, 7}, {10, -7}}, textString = "wspeed"), Text(origin = {16, 67}, extent = {{-10, 7}, {10, -7}}, textString = "power"), Line(origin = {17.9275, 4.51222}, points = {{-17.9274, -3.15563}, {20.0726, -43.1556}, {30.0726, -31.1556}, {-17.9274, -3.15563}, {-27.9274, 42.8444}, {-9.92744, 42.8444}, {-17.9274, -5.15563}}), Line(origin = {-23.7015, -37.4544}, points = {{23.7014, -41.189}, {23.7014, 38.811}, {-16.2986, -1.189}, {-26.2986, 10.811}, {23.7014, 38.811}})}, coordinateSystem(initialScale = 0.1)));
    end WTSys;

    model BatterySystem
      parameter Real CR = 1.0 "Charing rate";
      parameter Real DR = 1.0 "Discharging rate";
      parameter Real MaxEnergy(unit = "Wh") = 30.0;
      parameter Real InitialCharge = 0.0 "% of MaxEnergy";
      Modelica.Blocks.Interfaces.RealOutput E annotation(
        Placement(visible = true, transformation(origin = {136, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput Min annotation(
        Placement(visible = true, transformation(origin = {22, 86}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {72, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Interfaces.PConnection Outlet annotation(
        Placement(visible = true, transformation(origin = {71, -91}, extent = {{-31, -31}, {31, 31}}, rotation = 270), iconTransformation(origin = {-21, -49}, extent = {{-29, -29}, {29, 29}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput SPOutlet annotation(
        Placement(visible = true, transformation(origin = {-132, -6}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput Mout annotation(
        Placement(visible = true, transformation(origin = {0, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {110, 90}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
      ELOGOW.Interfaces.PConnection Inlet annotation(
        Placement(visible = true, transformation(origin = {81, 93}, extent = {{-31, -31}, {31, 31}}, rotation = 90), iconTransformation(origin = {-79, -47}, extent = {{-31, -31}, {31, 31}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealInput SPInlet annotation(
        Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
      ELOGOW.Batteries.LB lb(CR = CR, DR = DR, MaxEnergy = MaxEnergy, InitialCharge = InitialCharge) annotation(
        Placement(visible = true, transformation(origin = {96, 8}, extent = {{-36, -36}, {36, 36}}, rotation = 0)));
      ELOGOW.Sensors.ESensor eSensor(MaxEnergy = MaxEnergy) annotation(
        Placement(visible = true, transformation(origin = {128, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ELOGOW.Controllers.PowContr InletC(MaxEnergy = MaxEnergy, Rate = CR) annotation(
        Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
      ELOGOW.Controllers.PowContr OutletC(MaxEnergy = MaxEnergy, Rate = DR) annotation(
        Placement(visible = true, transformation(origin = {-9, -5}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
      ELOGOW.Sensors.PowerSensor powerSensor annotation(
        Placement(visible = true, transformation(origin = {30, -46}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
      ELOGOW.Sensors.PowerSensor powerSensor1 annotation(
        Placement(visible = true, transformation(origin = {62, 58}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    equation
      connect(lb.E, eSensor.E) annotation(
        Line(points = {{118, -14}, {120, -14}, {120, 68}, {120, 68}}, color = {0, 170, 0}));
      connect(eSensor.V, E) annotation(
        Line(points = {{136, 68}, {136, 110}}, color = {0, 0, 127}));
      connect(lb.Inlet, Inlet) annotation(
        Line(points = {{68, 16}, {82, 16}, {82, 93}, {81, 93}}));
      connect(lb.Outlet, Outlet) annotation(
        Line(points = {{68, -14}, {84, -14}, {84, -90}, {72, -90}}));
      connect(SPInlet, InletC.SP) annotation(
        Line(points = {{-130, 40}, {-22, 40}}, color = {0, 0, 127}));
      connect(InletC.C, lb.Ci) annotation(
        Line(points = {{4, 40}, {68, 40}, {68, 24}, {68, 24}}, color = {0, 0, 127}));
      connect(SPOutlet, OutletC.SP) annotation(
        Line(points = {{-132, -6}, {-22, -6}}, color = {0, 0, 127}));
      connect(OutletC.C, lb.Co) annotation(
        Line(points = {{6, -6}, {36, -6}, {36, -2}, {68, -2}, {68, -4}}, color = {0, 0, 127}));
      connect(lb.Outlet, powerSensor.P) annotation(
        Line(points = {{68, -14}, {70, -14}, {70, -46}, {38, -46}}));
      connect(powerSensor.V, Mout) annotation(
        Line(points = {{20, -46}, {0, -46}, {0, -100}}, color = {0, 0, 127}));
      connect(lb.Inlet, powerSensor1.P) annotation(
        Line(points = {{68, 16}, {76, 16}, {76, 58}, {68, 58}, {68, 58}}));
      connect(powerSensor1.V, Min) annotation(
        Line(points = {{54, 58}, {22, 58}, {22, 86}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Text(origin = {-67, 63}, extent = {{-59, 23}, {-27, -13}}, textString = "SP Inlet"), Text(origin = {18, 66}, extent = {{-24, 10}, {6, -2}}, textString = "E"), Rectangle(origin = {43, 71}, extent = {{-183, 29}, {95, -101}}), Text(origin = {113, 71}, extent = {{-13, 9}, {13, -9}}, textString = "MPout"), Text(origin = {-13, 65}, extent = {{-59, 23}, {-21, -17}}, textString = "SP Outlet"), Rectangle(origin = {63, 26}, rotation = 90, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-55, 2}, {33, -68}}), Text(origin = {76, 63}, extent = {{-14, 19}, {4, -3}}, textString = "MPin"), Rectangle(origin = {-11, 4}, rotation = 90, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-33, 128}, {55, -72}}), Polygon(origin = {-8, 20}, rotation = 90, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{4, 68}, {-18, -2}, {-4, 4}, {-14, -52}, {6, 12}, {-8, 8}, {-6, 12}, {4, 68}})}, coordinateSystem(extent = {{-140, -100}, {140, 100}}, initialScale = 0.1)),
        Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
    end BatterySystem;

    model Sys
      parameter Integer tnr = 1 "Number of turbines";
      ELOGOW.Grids.WTG Grid(emissionTable(tableID "External table object")) annotation(
        Placement(transformation(origin = {248, -340}, extent = {{-164, -164}, {164, 164}})));
      ELOGOW.Systems.BatterySystem B(CR = 1, DR = 1, InitialCharge = 30.01, MaxEnergy = 22e6) annotation(
        Placement(transformation(origin = {-106, -349.6}, extent = {{-113.6, -81.14279999999999}, {113.6, 81.14279999999999}}, rotation = 90)));
      ELOGOW.Systems.WTSys WT(tnr = tnr, Turbine(Ptable(tableID "External table object"))) annotation(
        Placement(transformation(origin = {-125, -113}, extent = {{-89, -89}, {89, 89}})));
      Modelica.Blocks.Interfaces.RealInput gtp1 annotation(
        Placement(transformation(origin = {-388, 218}, extent = {{-36, -36}, {36, 36}}), iconTransformation(origin = {-363, 199}, extent = {{-35, -35}, {35, 35}})));
      Modelica.Blocks.Interfaces.RealInput ws annotation(
        Placement(transformation(origin = {-426, -88}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-363, -1}, extent = {{-35, -35}, {35, 35}})));
      Modelica.Blocks.Interfaces.RealInput bi annotation(
        Placement(transformation(origin = {-402, -366}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-361, -135}, extent = {{-35, -35}, {35, 35}})));
      Modelica.Blocks.Interfaces.RealInput bo annotation(
        Placement(transformation(origin = {-400, -324}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-362, -244}, extent = {{-36, -36}, {36, 36}})));
      Modelica.Blocks.Interfaces.RealInput demand annotation(
        Placement(transformation(origin = {356, -306}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-180, -366}, extent = {{-32, -32}, {32, 32}}, rotation = 90)));
      ELOGOW.Sources.WindSource windSource annotation(
        Placement(transformation(origin = {-300, -92}, extent = {{-50, -50}, {50, 50}})));
      Modelica.Blocks.Interfaces.RealOutput BE annotation(
        Placement(transformation(origin = {-382, -222}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {352, 282}, extent = {{-44, -44}, {44, 44}})));
      Modelica.Blocks.Interfaces.RealOutput CO2 annotation(
        Placement(transformation(origin = {364, -170}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {120, -374}, extent = {{-34, -34}, {34, 34}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput nox annotation(
        Placement(transformation(origin = {366, -130}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {241, -371}, extent = {{-33, -33}, {33, 33}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput mgtp1 annotation(
        Placement(transformation(origin = {410, 332}, extent = {{-34, -34}, {34, 34}}), iconTransformation(origin = {353, 179}, extent = {{-45, -45}, {45, 45}})));
      Modelica.Blocks.Interfaces.RealOutput wtp annotation(
        Placement(transformation(origin = {375, -21}, extent = {{-33, -33}, {33, 33}}), iconTransformation(origin = {349, -85}, extent = {{-41, -41}, {41, 41}})));
      ELOGOW.Sensors.PowerSensor powerSensor annotation(
        Placement(transformation(origin = {270, 332}, extent = {{-36, -36}, {36, 36}})));
      Modelica.Blocks.Interfaces.RealInput gtp2 annotation(
        Placement(transformation(origin = {-394, 78}, extent = {{-26, -26}, {26, 26}}), iconTransformation(origin = {-362, 108}, extent = {{-34, -34}, {34, 34}})));
      Modelica.Blocks.Interfaces.RealOutput mgtp2 annotation(
        Placement(transformation(origin = {405, 251}, extent = {{-31, -31}, {31, 31}}), iconTransformation(origin = {352, 80}, extent = {{-44, -44}, {44, 44}})));
      ELOGOW.Sensors.PowerSensor powerSensor2 annotation(
        Placement(transformation(origin = {222, 104}, extent = {{-34, -34}, {34, 34}})));
      Modelica.Blocks.Interfaces.BooleanInput trigger annotation(
        Placement(transformation(origin = {-392, 324}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-360, 290}, extent = {{-36, -36}, {36, 36}})));
      ELOGOW.Sensors.PowerSensor powerSensor1 annotation(
        Placement(transformation(origin = {111, -141}, extent = {{-29, -29}, {29, 29}})));
      ELOGOW.GasTurbines.GasTurb gt1(MaxPower = 13e6, StartupTime = 900, emissionTable(tableID "External table object")) annotation(
        Placement(transformation(origin = {-104, 254}, extent = {{-86, -86}, {86, 86}})));
      ELOGOW.GasTurbines.GasTurb gt2(MaxPower = 13e6, StartupTime = 900, emissionTable(tableID "External table object")) annotation(
        Placement(transformation(origin = {-109, 39}, extent = {{-89, -89}, {89, 89}})));
    equation
//der(TotCO2) = CO2;
      CO2 = gt1.co2 + gt2.co2;
      nox = gt1.nox + gt2.nox;
      Grid.Demand.P = demand;
      connect(B.Outlet, Grid.BS) annotation(
        Line(points = {{-66, -367}, {73.5, -367}, {73.5, -379}, {205, -379}}));
      connect(Grid.BD, B.Inlet) annotation(
        Line(points = {{207, -450}, {16.38, -450}, {16.38, -414}, {-68, -414}}));
      connect(WT.Pout, Grid.WTS) annotation(
        Line(points = {{-50, -113}, {-15.76, -113}, {-15.76, -320}, {205, -320}}));
      connect(bo, B.SPOutlet) annotation(
        Line(points = {{-400, -324}, {-239.5, -324}, {-239.5, -390}, {-179, -390}}, color = {0, 0, 127}));
      connect(bi, B.SPInlet) annotation(
        Line(points = {{-402, -366}, {-241.5, -366}, {-241.5, -439}, {-179, -439}}, color = {0, 0, 127}));
      connect(ws, windSource.u) annotation(
        Line(points = {{-426, -88}, {-369, -88}, {-369, -91}, {-330, -91}}, color = {0, 0, 127}));
      connect(powerSensor.V, mgtp1) annotation(
        Line(points = {{300, 332}, {410, 332}}, color = {0, 0, 127}));
      connect(powerSensor2.V, mgtp2) annotation(
        Line(points = {{250, 104}, {285.5, 104}, {285.5, 253}, {286.25, 253}, {286.25, 251}, {405, 251}}, color = {0, 0, 127}));
      connect(powerSensor1.V, wtp) annotation(
        Line(points = {{134.78, -141}, {183.78, -141}, {183.78, -21}, {375, -21}}, color = {0, 0, 127}));
      connect(trigger, gt1.u) annotation(
        Line(points = {{-392, 324}, {-299.5, 324}, {-299.5, 318}, {-173, 318}}, color = {255, 0, 255}));
      connect(gtp1, gt1.Psp) annotation(
        Line(points = {{-388, 218}, {-290, 218}, {-290, 254}, {-173, 254}}, color = {0, 0, 127}));
      connect(trigger, gt2.u) annotation(
        Line(points = {{-392, 324}, {-308, 324}, {-308, 105}, {-180, 105}}, color = {255, 0, 255}));
      connect(gtp2, gt2.Psp) annotation(
        Line(points = {{-394, 78}, {-298, 78}, {-298, 39}, {-180, 39}}, color = {0, 0, 127}));
      connect(gt1.Pout, powerSensor.P) annotation(
        Line(points = {{-34, 253}, {120, 253}, {120, 332}, {248, 332}}));
      connect(gt2.Pout, powerSensor2.P) annotation(
        Line(points = {{-37, 38}, {134, 38}, {134, 104}, {200, 104}}));
      connect(windSource.wind, WT.Wind) annotation(
        Line(points = {{-276, -92}, {-196, -92}, {-196, -114}}));
      connect(BE, B.E) annotation(
        Line(points = {{-382, -222}, {-208, -222}, {-208, -342}, {-180, -342}}, color = {0, 0, 127}));
      connect(WT.Pout, powerSensor1.P) annotation(
        Line(points = {{-50, -112}, {92, -112}, {92, -140}}));
      connect(gt2.Pout, Grid.GTS1) annotation(
        Line(points = {{-36, 38}, {58, 38}, {58, -212}, {208, -212}}));
      connect(gt1.Pout, Grid.GTS2) annotation(
        Line(points = {{-34, 254}, {36, 254}, {36, -272}, {206, -272}}));
      annotation(
        Icon(coordinateSystem(extent = {{-400, -400}, {400, 400}}), graphics = {Rectangle(extent = {{-313.02, 338.129}, {313.02, -338.129}}, origin = {-9.938140000000001, 0.829315}), Text(textString = "GTSP1", horizontalAlignment = TextAlignment.Left, extent = {{-239.561, 26.884}, {-85.56059999999999, -17.116}}, origin = {-68.43940000000001, 195.116}), Text(textString = "Demand", extent = {{-69.7667, 36.1}, {112.233, -39.9}}, origin = {-186.233, -298.1}), Text(textString = "Battery  Level", horizontalAlignment = TextAlignment.Left, extent = {{-367.11, 34.22}, {-131.11, -21.78}}, origin = {419.11, 281.78}), Text(textString = "CO2", horizontalAlignment = TextAlignment.Left, extent = {{-121.334, 28.1111}, {-43.3334, -17.8889}}, origin = {207.334, -314.111}), Text(textString = "NOx", horizontalAlignment = TextAlignment.Left, extent = {{-105.778, 28.1111}, {-37.7777, -17.8889}}, origin = {315.777, -310.111}), Text(textString = "GTP1", horizontalAlignment = TextAlignment.Left, extent = {{-124.444, 46.4443}, {-44.4444, -29.5556}}, origin = {334.444, 169.556}), Text(textString = "WTP", horizontalAlignment = TextAlignment.Left, extent = {{-118.222, 30.5555}, {-42.2222, -19.4445}}, origin = {336.222, -92.55500000000001}), Text(textString = "GTSP2", horizontalAlignment = TextAlignment.Left, extent = {{-174.23, 39.104}, {-62.23, -24.896}}, origin = {-139.77, 100.896}), Text(textString = "GTP2", horizontalAlignment = TextAlignment.Left, extent = {{-124.444, 41.5555}, {-44.4444, -26.4445}}, origin = {330.444, 74.44499999999999}), Text(textString = "Start/Stop", horizontalAlignment = TextAlignment.Left, lineThickness = 1, extent = {{-118.372, 48.88}, {67.6284, -31.12}}, origin = {-193.628, 285.12}), Text(textString = "Bi", horizontalAlignment = TextAlignment.Left, extent = {{-136.889, 35.4444}, {-48.8889, -22.5556}}, origin = {-169.111, -143.444}), Text(textString = "Bo", horizontalAlignment = TextAlignment.Left, extent = {{-96.4444, 33}, {-34.4444, -21}}, origin = {-219.556, -255}), Text(textString = "WS", horizontalAlignment = TextAlignment.Left, extent = {{-121.333, 34.2222}, {-43.3334, -21.7778}}, origin = {-184.667, -8.222200000000001})}),
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}})));
    end Sys;
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {-7, 15}, fillColor = {5, 190, 5}, fillPattern = FillPattern.Solid, extent = {{-73, 77}, {89, -83}}, endAngle = 360), Text(origin = {4, -19}, lineThickness = 0.5, extent = {{-64, 77}, {60, -19}}, textString = "SYS")}));
  end Systems;

  package Controllers
    block PowContr
      parameter Real Rate = 1.0 "Charing rate";
      parameter Real MaxEnergy(unit = "Wh") = 30.0;
      constant Real WH_TO_J = 3.6e+3;
      Real EMax(unit = "Joules") = MaxEnergy * WH_TO_J;
      Real CableMax = Rate * EMax / 3600;
      Modelica.Blocks.Interfaces.RealInput SP annotation(
        Placement(visible = true, transformation(origin = {-88, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-81, -3}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput C annotation(
        Placement(visible = true, transformation(origin = {74, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {87, -1}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      Real sp;
    equation
      sp = min(SP, CableMax);
      C = max(0, sp / CableMax);
      annotation(
        Icon(graphics = {Text(origin = {-83, 35}, extent = {{-23, 17}, {23, -17}}, textString = "SP"), Text(origin = {0, 135}, extent = {{-64, -37}, {56, -79}}, textString = "%name"), Text(origin = {81, 37}, extent = {{-17, 7}, {17, -17}}, textString = "C"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
    end PowContr;

    model Trigger
      parameter Boolean Initial = true "initial trigger";
      parameter Real low = 30 "Low charge %";
      parameter Real high = 60 "High charge %";
      Modelica.Blocks.Interfaces.RealInput BL annotation(
        Placement(transformation(origin = {-90, 50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-1, 341}, extent = {{-57, -57}, {57, 57}}, rotation = -90)));
      Modelica.Blocks.Interfaces.BooleanOutput y annotation(
        Placement(transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -338}, extent = {{-58, -58}, {58, 58}}, rotation = -90)));
    initial equation
      y = Initial;
    equation
      y = BL < low or pre(y) and BL < high;
//  if BL < low then
//    y = true;
//  elseif BL > high then
//    y = false;
//  else
//    y = delay(y, 1);
//  end if;
      annotation(
        Icon(coordinateSystem(extent = {{-400, -400}, {400, 400}}), graphics = {Rectangle(extent = {{-415.169, 194.338}, {302.406, -360.912}}, origin = {56.4429, 82.7607}), Text(textString = "Battery Level", extent = {{-231.385, 42.75}, {144.615, -33.25}}, origin = {13.3848, 233.25}), Text(textString = "Start/Stop GT", extent = {{-227.689, 52.875}, {142.311, -41.125}}, origin = {27.6884, -234.875})}),
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}})));
    end Trigger;

    model Strategy2
      parameter Boolean UseBattery = false "Use a battery";
      Modelica.Blocks.Interfaces.BooleanInput Trigger annotation(
        Placement(transformation(origin = {-4, 310}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 352}, extent = {{-44, -44}, {44, 44}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput GT1 annotation(
        Placement(transformation(origin = {-324, -50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-343, 159}, extent = {{-55, -55}, {55, 55}})));
      Modelica.Blocks.Interfaces.RealInput GT2 annotation(
        Placement(transformation(origin = {-334, 62}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-342, -7.10543e-15}, extent = {{-54, -54}, {54, 54}})));
      Modelica.Blocks.Interfaces.RealInput WP annotation(
        Placement(transformation(origin = {-316, 196}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-336, -242}, extent = {{-58, -58}, {58, 58}})));
      Modelica.Blocks.Interfaces.RealOutput GTSP1 annotation(
        Placement(transformation(origin = {126, -98}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {345, 179}, extent = {{-43, -43}, {43, 43}})));
      Modelica.Blocks.Interfaces.RealOutput GTSP2 annotation(
        Placement(transformation(origin = {114, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {345, 43}, extent = {{-43, -43}, {43, 43}})));
      Modelica.Blocks.Interfaces.RealOutput Bi annotation(
        Placement(transformation(origin = {118, 24}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {345, -105}, extent = {{-43, -43}, {43, 43}})));
      Modelica.Blocks.Interfaces.RealOutput Bo annotation(
        Placement(transformation(origin = {112, 88}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {341, -203}, extent = {{-39, -39}, {39, 39}})));
      Modelica.Blocks.Interfaces.RealInput Demand annotation(
        Placement(transformation(origin = {46, -358}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {3, -353}, extent = {{-43, -43}, {43, 43}}, rotation = 90)));
    equation
// loss = Demand - WP - GT1 - GT2;
//gt_factor = 1.1;
      GTSP2 = GTSP1;
      if UseBattery then
        if Demand - GT1 - GT2 - WP < 0 then
          Bo = 0;
          Bi = -(Demand - GT1 - GT2 - WP);
        else
          Bo = Demand - GT1 - GT2 - WP;
          Bi = 0;
        end if;
        if Trigger == true then
          if Demand > WP then
            GTSP1 = (Demand - WP) * 1.1 * 0.5;
          else
            GTSP1 = 0;
          end if;
        else
          GTSP1 = 0;
        end if;
      else
        Bi = 0;
        Bo = 0;
        if Demand > WP then
          GTSP1 = (Demand - WP) * 1 * 0.5;
        else
          GTSP1 = 0;
        end if;
      end if;
      annotation(
        Icon(coordinateSystem(extent = {{-400, -400}, {400, 400}}), graphics = {Rectangle(extent = {{-289.661, 302.525}, {289.661, -302.525}}, origin = {8.5236, -3.14572}), Text(textString = "Trigger", extent = {{-85, 25}, {85, -25}}, origin = {-13, 267}), Text(textString = "GTP2", extent = {{-60, 49}, {60, -49}}, origin = {-222, 9}), Text(textString = "WP", horizontalAlignment = TextAlignment.Left, extent = {{-59, 31}, {59, -31}}, origin = {-215, -231}), Text(textString = "GTP1", extent = {{-60, 45}, {60, -45}}, origin = {-222, 161}), Text(textString = "GTSP1", extent = {{-75, 48}, {75, -48}}, origin = {221, 182}), Text(textString = "GTSP2", extent = {{-71, 38}, {71, -38}}, origin = {221, 40}), Text(textString = "Bo", extent = {{-35, 31}, {35, -31}}, origin = {263, -197}), Text(textString = "Bi", extent = {{-56, 37}, {56, -37}}, origin = {260, -97}), Text(textString = "Demand", horizontalAlignment = TextAlignment.Left, extent = {{-86, 49}, {86, -49}}, origin = {-2, -269})}),
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}})));
    end Strategy2;
    annotation(
      Diagram,
      Icon(graphics = {Rectangle(origin = {0, 12}, fillColor = {218, 218, 218}, fillPattern = FillPattern.Solid, lineThickness = 1.75, extent = {{-58, 64}, {58, -64}}), Text(origin = {-34, 36}, extent = {{-18, 36}, {80, -78}}, textString = "C")}));
  end Controllers;

  package Grids
    block WTG
      constant Real MaxPower = 20e6;
      constant Real maxCO2 = 167;
      parameter Real Frequency = 50;
      parameter Real Voltage = 230;
      Real total_in;
      Real total_out;
      SI.Power Losses;
      SI.Energy ELost;
      Real CO2Cum;
      Real CO2;
      Real NOxCum;
      Real NOx;
      ELOGOW.Interfaces.PConnection BS annotation(
        Placement(visible = true, transformation(origin = {-12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-26, -24}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
      ELOGOW.Interfaces.PConnection BD annotation(
        Placement(visible = true, transformation(origin = {-32, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-25, -67}, extent = {{-21, -21}, {21, 21}}, rotation = 180)));
      ELOGOW.Interfaces.PConnection WTS annotation(
        Placement(visible = true, transformation(origin = {-20, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-26, 12}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
      ELOGOW.Interfaces.PConnection Demand annotation(
        Placement(visible = true, transformation(origin = {26, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {29, 1}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
      ELOGOW.Interfaces.PConnection GTS1 annotation(
        Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-24, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Tables.CombiTable1Ds emissionTable(columns = 2:3, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints, fileName = files + "emission.txt", tableName = "myTable", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {14, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      ELOGOW.Interfaces.PConnection GTS2 annotation(
        Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-26, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    initial equation
      ELost = 0;
    equation
      Demand.P + Losses + BD.P = WTS.P + BS.P + GTS1.P + GTS2.P;
      total_in = WTS.P + BS.P + GTS1.P + GTS2.P;
      total_out = Demand.P + Losses + BD.P;
//emissionTable.u = (WTS.P + BS.P) / MaxPower;
      emissionTable.u = abs(Losses);
      CO2 = emissionTable.y[1];
      NOx = emissionTable.y[2];
      der(ELost) = abs(Losses);
      der(CO2Cum) = CO2;
      der(NOxCum) = NOx;
//* maxCO2;
      annotation(
        Icon(graphics = {Line(origin = {0, -5}, points = {{0, 85}, {0, -69}, {0, -73}}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
    end WTG;
    annotation(
      Icon(graphics = {Line(points = {{-80, 0}, {80, 0}}, thickness = 1), Line(origin = {0, -4}, points = {{0, -56}, {0, 56}}, thickness = 1), Line(origin = {-60, 26}, points = {{0, -26}, {0, 26}}, thickness = 1), Line(origin = {-30.7965, 27.0619}, points = {{0, -26}, {0, 26}}, thickness = 1), Line(origin = {29.469, 26.531}, points = {{0, -26}, {0, 26}}, thickness = 1), Line(origin = {60, 26.531}, points = {{0, -26}, {0, 26}}, thickness = 1)}));
  end Grids;

  package WindTurbines
    block Wind
      Modelica.Blocks.Interfaces.RealOutput wind annotation(
        Placement(visible = true, transformation(origin = {56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {68, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    equation
      wind = 8;
      annotation(
        Icon(graphics = {Text(origin = {-30, -5}, extent = {{-56, 89}, {68, -71}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));
    end Wind;

    model WindTurbine
      parameter Integer tnr = 1 "Number of turbines";
      ELOGOW.Interfaces.PConnection Pout annotation(
        Placement(visible = true, transformation(origin = {-6, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {84, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
      ELOGOW.Interfaces.Wind Wind annotation(
        Placement(visible = true, transformation(origin = {-86, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
      Modelica.Blocks.Tables.CombiTable1D Ptable(fileName = files + "cp.txt", smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table = [0, 0; 4, 0; 6, 1500; 10, 7000; 11, 10500; 24, 10600; 25, 0], tableName = "power", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {-2, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
//Pout.P = 0.5 * PI * (diameter / 2) ^ 2 * Cp * 1.225 * Wind.u ^ 3;
      Ptable.u[1] = Wind.u;
      Pout.P = Ptable.y[1] * 1e7 * tnr;
      annotation(
        Icon(graphics = {Text(origin = {-6, 72}, extent = {{-38, 10}, {38, -10}}, textString = "%name"), Line(origin = {-23.7015, -37.4544}, points = {{23.7014, -33.189}, {23.7014, 38.811}, {-16.2986, -1.189}, {-26.2986, 10.811}, {23.7014, 38.811}}), Line(origin = {17.9275, 4.51222}, points = {{-17.9274, -3.15563}, {20.0726, -43.1556}, {30.0726, -31.1556}, {-17.9274, -3.15563}, {-27.9274, 42.8444}, {-9.92744, 42.8444}, {-17.9274, -5.15563}}), Text(origin = {83, -90}, extent = {{-17, 6}, {17, -6}}, textString = "- CO2")}, coordinateSystem(initialScale = 0.1)));
    end WindTurbine;
  end WindTurbines;

  package Sources
    block WindSource
      ELOGOW.Interfaces.Wind wind annotation(
        Placement(visible = true, transformation(origin = {82, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {48, -2}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput u annotation(
        Placement(visible = true, transformation(origin = {-20, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    equation
      wind.u = u;
      annotation(
        Icon(graphics = {Rectangle(origin = {5, 30}, extent = {{-85, 50}, {75, -110}}), Text(origin = {-5, 59}, extent = {{-45, 15}, {45, -15}}, textString = "Wind Source")}, coordinateSystem(initialScale = 0.1)));
    end WindSource;

    block ERA5Source
      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(fileName = files + "speedmodelica.txt", tableName = "speed", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {5, -1}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
      ELOGOW.Interfaces.Wind wind annotation(
        Placement(visible = true, transformation(origin = {86, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, -2}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput y annotation(
        Placement(visible = true, transformation(origin = {92, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      combiTimeTable.y[1] = wind.u;
      combiTimeTable.y[1] = y;
      annotation(
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {-19, -2}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Solid, extent = {{-41, 42}, {41, -42}}, endAngle = 360)}));
    end ERA5Source;
    annotation(
      Icon(graphics = {Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-70, -4.5}, {0, 4.5}}), Polygon(origin = {23.3333, 0}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-23.333, 30}, {46.667, 0}, {-23.333, -30}, {-23.333, 30}})}));
  end Sources;

  package GasTurbines
    model GasTurb
      parameter Real MaxPower = 20e6;
      parameter Real maxCO2 = 167;
      parameter Real maxNOx = 6.6e-4;
      parameter Real initialP = 0;
      parameter Real StartupTime = 900;
      SI.Energy E;
      Modelica.Blocks.Interfaces.RealInput Psp annotation(
        Placement(visible = true, transformation(origin = {-335, 133}, extent = {{-85, -85}, {85, 85}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput nox annotation(
        Placement(visible = true, transformation(origin = {572, -284}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {60, 84}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput co2 annotation(
        Placement(visible = true, transformation(origin = {575, -185}, extent = {{-43, -43}, {43, 43}}, rotation = 0), iconTransformation(origin = {1, 85}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
      ELOGOW.Interfaces.PConnection Pout annotation(
        Placement(visible = true, transformation(origin = {150, -302}, extent = {{-78, -78}, {78, 78}}, rotation = 0), iconTransformation(origin = {81, -1}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanInput u annotation(
        Placement(visible = true, transformation(origin = {-348, 310}, extent = {{-42, -42}, {42, 42}}, rotation = 0), iconTransformation(origin = {-80, 74}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Logical.Timer timer annotation(
        Placement(visible = true, transformation(origin = {-180, 310}, extent = {{-50, -50}, {50, 50}}, rotation = 0)));
      Modelica.Blocks.Tables.CombiTable1Ds emissionTable(columns = 2:3, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints, fileName = files + "emission.txt", tableName = "myTable", tableOnFile = true) annotation(
        Placement(visible = true, transformation(origin = {538, 180}, extent = {{-64, -64}, {64, 64}}, rotation = 0)));
      Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = StartupTime) annotation(
        Placement(visible = true, transformation(origin = {-14, 310}, extent = {{-50, -50}, {50, 50}}, rotation = 0)));
      Modelica.Blocks.Math.Product product annotation(
        Placement(visible = true, transformation(origin = {303, 299}, extent = {{-49, -49}, {49, 49}}, rotation = 0)));
      Modelica.Blocks.Math.Feedback feedback annotation(
        Placement(visible = true, transformation(origin = {-137, -93}, extent = {{-69, -69}, {69, 69}}, rotation = 0)));
      ELOGOW.Sensors.PowerSensor powerSensor annotation(
        Placement(visible = true, transformation(origin = {-35, -311}, extent = {{71, -71}, {-71, 71}}, rotation = 0)));
      Modelica.Blocks.Math.BooleanToReal booleanToReal annotation(
        Placement(visible = true, transformation(origin = {149, 331}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
      Modelica.Blocks.Continuous.PI pi annotation(
        Placement(visible = true, transformation(origin = {108, -138}, extent = {{-68, -68}, {68, 68}}, rotation = 0)));
    equation
      emissionTable.u = Pout.P;
      co2 = emissionTable.y[1];
      nox = emissionTable.y[2];
      Pout.P = pi.y;
      der(E) = Pout.P;
//product.y;
//pi.y;
      connect(u, timer.u) annotation(
        Line(points = {{-348, 310}, {-240, 310}}, color = {255, 0, 255}));
      connect(timer.y, greaterThreshold.u) annotation(
        Line(points = {{-125, 310}, {-74, 310}}, color = {0, 0, 127}));
      connect(Psp, product.u2) annotation(
        Line(points = {{-334, 134}, {82, 134}, {82, 270}, {244, 270}}, color = {0, 0, 127}));
      connect(product.y, feedback.u1) annotation(
        Line(points = {{357, 299}, {386, 299}, {386, -14}, {-252, -14}, {-252, -92}, {-192, -92}}, color = {0, 0, 127}));
      connect(Pout, powerSensor.P) annotation(
        Line(points = {{150, -302}, {10, -302}, {10, -310}}));
      connect(powerSensor.V, feedback.u2) annotation(
        Line(points = {{-94, -310}, {-136, -310}, {-136, -148}}, color = {0, 0, 127}));
      connect(greaterThreshold.y, booleanToReal.u) annotation(
        Line(points = {{42, 310}, {74, 310}, {74, 331}, {105, 331}}, color = {255, 0, 255}));
      connect(booleanToReal.y, product.u1) annotation(
        Line(points = {{190, 331}, {244, 331}, {244, 328}}, color = {0, 0, 127}));
      connect(feedback.y, pi.u) annotation(
        Line(points = {{-74, -92}, {-36, -92}, {-36, -138}, {26, -138}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Text(origin = {-91, -36}, extent = {{-11, 10}, {39, -2}}, textString = "Power setpoint"), Text(origin = {10, 58}, extent = {{-32, 10}, {16, -8}}, textString = "CO2"), Text(origin = {-89, 42}, extent = {{-11, 10}, {33, -8}}, textString = "Start/Stop"), Polygon(origin = {10, 0}, points = {{-50, 40}, {-50, -40}, {-30, -20}, {-10, -20}, {50, -40}, {50, 40}, {-10, 20}, {-30, 20}, {-30, 20}, {-50, 40}}), Text(origin = {66, 58}, extent = {{-32, 10}, {16, -8}}, textString = "NOx")}),
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}})));
    end GasTurb;
    annotation(
      Icon(graphics = {Polygon(fillColor = {179, 179, 179}, fillPattern = FillPattern.Solid, points = {{-80, -60}, {-80, 60}, {-40, 20}, {0, 20}, {80, 60}, {80, -60}, {0, -20}, {-40, -20}, {-40, -20}, {-80, -60}})}));
  end GasTurbines;

  package Paper
    model Storage
      Modelica.Blocks.Sources.Sine setpoint_inlet(amplitude = 1e6, freqHz = 0.01666, offset = 1e6, startTime = 0) annotation(
        Placement(visible = true, transformation(origin = {-107, -67}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
      ELOGOW.Systems.BatterySystem batterySystem(InitialCharge = 50, MaxEnergy = 20e6) annotation(
        Placement(visible = true, transformation(origin = {100.143, 20.2}, extent = {{-140.2, -100.143}, {140.2, 100.143}}, rotation = 90)));
      Modelica.Blocks.Sources.Sine setpoint_out(amplitude = 1e6, freqHz = 0.01666, offset = 1e6, startTime = 60) annotation(
        Placement(visible = true, transformation(origin = {-112, 44}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
    equation
      connect(setpoint_inlet.y, batterySystem.SPInlet) annotation(
        Line(points = {{-73, -67}, {-23, -67}, {-23, -90}, {10, -90}}, color = {0, 0, 127}));
      connect(setpoint_out.y, batterySystem.SPOutlet) annotation(
        Line(points = {{-79, 44}, {-30, 44}, {-30, -30}, {10, -30}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
    end Storage;

    model GT
      Modelica.Blocks.Sources.BooleanPulse booleanPulse(period = 4000, startTime = 0) annotation(
        Placement(visible = true, transformation(origin = {-251, 219}, extent = {{-103, -103}, {103, 103}}, rotation = 0)));
      Modelica.Blocks.Sources.Constant const(k = 13e6) annotation(
        Placement(visible = true, transformation(origin = {-260, -138}, extent = {{-106, -106}, {106, 106}}, rotation = 0)));
      ELOGOW.GasTurbines.GasTurb gasTurb annotation(
        Placement(visible = true, transformation(origin = {283, -35}, extent = {{-253, -253}, {253, 253}}, rotation = 0)));
    equation
      connect(booleanPulse.y, gasTurb.u) annotation(
        Line(points = {{-138, 219}, {-2, 219}, {-2, 152}, {81, 152}}, color = {255, 0, 255}));
      connect(const.y, gasTurb.Psp) annotation(
        Line(points = {{-143, -138}, {10, -138}, {10, -35}, {81, -35}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}})),
        __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"));
    end GT;

    model Source
      ELOGOW.Sources.ERA5Source eRA5Source annotation(
        Placement(visible = true, transformation(origin = {-117, -1}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
    end Source;

    model W
      ELOGOW.Systems.WTSys wTSys annotation(
        Placement(visible = true, transformation(origin = {139, -75}, extent = {{-299, -299}, {299, 299}}, rotation = 0)));
      ELOGOW.Sources.ERA5Source eRA5Source annotation(
        Placement(visible = true, transformation(origin = {-295, 181}, extent = {{-159, -159}, {159, 159}}, rotation = 0)));
    equation
      connect(eRA5Source.wind, wTSys.Wind) annotation(
        Line(points = {{-212, 178}, {-212, 322}, {-100, 322}, {-100, -80}}));
      annotation(
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}})));
    end W;

    model Sim
      ELOGOW.Systems.Sys sys(tnr = 1) annotation(
        Placement(visible = true, transformation(origin = {144, -108}, extent = {{-194, -194}, {194, 194}}, rotation = 0)));
      ELOGOW.Controllers.Strategy2 Opt(UseBattery = true) annotation(
        Placement(transformation(origin = {-250.5, -100.5}, extent = {{-131.5, -131.5}, {131.5, 131.5}})));
      ELOGOW.Controllers.Trigger trigger(Initial = false, low = 30) annotation(
        Placement(transformation(origin = {-218.5, 214.5}, extent = {{-91.5, -91.5}, {91.5, 91.5}})));
      ELOGOW.Sources.ERA5Source wind annotation(
        Placement(visible = true, transformation(origin = {-527.5, -258.5}, extent = {{-81.5, -81.5}, {81.5, 81.5}}, rotation = 0)));
      ELOGOW.Sensors.EmissionSensor emissionSensor annotation(
        Placement(transformation(origin = {456.5, -345.5}, extent = {{-94.5, -94.5}, {94.5, 94.5}})));
      Modelica.Blocks.Sources.Sine PowerDemand(amplitude = 2e6, freqHz = 1e-5, offset = 12e6) annotation(
        Placement(visible = true, transformation(origin = {-420.5, -449.5}, extent = {{-76.5, -76.5}, {76.5, 76.5}}, rotation = 0)));
    equation
//GT = sys.mgtp1 + sys.mgtp2;
      connect(sys.BE, trigger.BL) annotation(
        Line(points = {{315, 29}, {348, 29}, {348, 318}, {-219, 318}, {-219, 293}}, color = {0, 0, 127}));
      connect(sys.mgtp1, Opt.GT1) annotation(
        Line(points = {{315, -21}, {337, -21}, {337, -22}, {364, -22}, {364, 343}, {-363, 343}, {-363, -48}}, color = {0, 0, 127}));
      connect(trigger.y, sys.trigger) annotation(
        Line(points = {{-218.3, 137.3}, {-218.3, 33}, {-31, 33}}, color = {255, 0, 255}));
      connect(trigger.y, Opt.Trigger) annotation(
        Line(points = {{-218.3, 137.3}, {-218.3, 132.3}, {-218.3, 20.3}, {-250.3, 20.3}, {-250.3, 15.3}}, color = {255, 0, 255}));
      connect(Opt.GTSP1, sys.gtp1) annotation(
        Line(points = {{-137, -42}, {-82, -42}, {-82, -11}, {-32, -11}}, color = {0, 0, 127}));
      connect(sys.mgtp2, Opt.GT2) annotation(
        Line(points = {{315, -69}, {393, -69}, {393, 377}, {-391, 377}, {-391, -100.5}, {-363, -100.5}}, color = {0, 0, 127}));
      connect(wind.y, sys.ws) annotation(
        Line(points = {{-453, -281}, {-73, -281}, {-73, -108}, {-32, -108}}, color = {0, 170, 0}, pattern = LinePattern.Dash, thickness = 0.5));
      connect(Opt.GTSP2, sys.gtp2) annotation(
        Line(points = {{-137, -86}, {-72, -86}, {-72, -56}, {-32, -56}}, color = {0, 0, 127}));
      connect(Opt.Bi, sys.bi) annotation(
        Line(points = {{-137, -135}, {-98, -135}, {-98, -173}, {-31, -173}}, color = {0, 0, 127}));
      connect(Opt.Bo, sys.bo) annotation(
        Line(points = {{-138, -167}, {-112, -167}, {-112, -226}, {-32, -226}}, color = {0, 0, 127}));
      connect(sys.wtp, Opt.WP) annotation(
        Line(points = {{313, -149}, {428, -149}, {428, 402}, {-421, 402}, {-421, -180}, {-361, -180}}, color = {0, 0, 127}));
      connect(sys.CO2, emissionSensor.CO2) annotation(
        Line(points = {{202, -289}, {197, -289}, {197, -317}, {381, -317}}, color = {0, 0, 127}));
      connect(sys.nox, emissionSensor.NOx) annotation(
        Line(points = {{261, -288}, {258, -288}, {258, -374}, {381, -374}}, color = {0, 0, 127}));
      connect(PowerDemand.y, sys.demand) annotation(
        Line(points = {{-336, -449.5}, {57, -449.5}, {57, -286}}, color = {0, 0, 127}));
      connect(PowerDemand.y, Opt.Demand) annotation(
        Line(points = {{-336, -449.5}, {-250, -449.5}, {-250, -217}}, color = {0, 0, 127}));
      annotation(
        __OpenModelica_simulationFlags(lv = "LOG_STATS", noRootFinding = "()", s = "dassl"),
        __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
        Icon(coordinateSystem(extent = {{-400, -400}, {400, 400}}, grid = {1, 1})),
        Diagram(coordinateSystem(extent = {{-400, -400}, {400, 400}}, grid = {1, 1}), graphics = {Text(origin = {-221.5, 215.5}, extent = {{-58.5, 31.5}, {58.5, -31.5}}, textString = "Trigger"), Text(origin = {135, -142}, extent = {{-78, 23}, {78, -23}}, textString = "Model"), Text(origin = {-257.5, -139}, extent = {{-61.5, 25}, {61.5, -25}}, textString = "Control")}),
        experiment(StopTime = 172800, StartTime = 0, Tolerance = 1e-06, Interval = 1, __esi_Solver(bEffJac = true, bSparseMat = true, typename = "CVODE"), __esi_SolverOptions(solver = "CVODE", typename = "ExternalCVODEOptionData"), __esi_MinInterval = "9.999999999999999e-10"));
    end Sim;
  end Paper;
  annotation(
    dateModified = "2021-05-14 13:58:53Z",
    uses(Modelica(version = "3.2.3")));
end ELOGOW;
