[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  ny = 5
  nz = 5
  xmin = -1
[]

[Variables]
  [./pressure]
  [../]
  [./temp]
  [../]
[]

[AuxVariables]
  [./strain_rate]
  [../]
[]

[Kernels]
  [./td_pressure]
    type = TimeDerivative
    variable = pressure
  [../]
  [./diff_pressure]
    type = CoefDiffusion
    variable = pressure
    coef = 0.25
  [../]
  [./td_temp]
    type = TimeDerivative
    variable = temp
  [../]
  [./diff_temp]
    type = Diffusion
    variable = temp
  [../]
  [./mh_temp]
    type = MechHeat
    variable = temp
    pressure = pressure
  [../]
  [./cp_press]
    type = ChemPressure
    variable = pressure
    temp = temp
  [../]
  [./ce_temp]
    type = ChemEndo
    variable = temp
  [../]
[]

[AuxKernels]
  [./strain_rate]
    type = StrainRateAux
    variable = strain_rate
    execute_on = timestep
    temp = temp
  [../]
[]

[BCs]
  [./left_pressure]
    type = DirichletBC
    variable = pressure
    boundary = left
    value = 0
  [../]
  [./right_pressure]
    type = DirichletBC
    variable = pressure
    boundary = right
    value = 0
  [../]
  [./left_temp]
    type = DirichletBC
    variable = temp
    boundary = left
    value = 0
  [../]
  [./right_temp]
    type = DirichletBC
    variable = temp
    boundary = right
    value = 0
  [../]
[]

[Materials]
  [./adim_rock]
    type = DimensionlessRock
    block = 0
    ar_c = 40
    alpha_2 = 3
    da = 1
    mu = 1e-3
    ar = 20
    delta = 1e-3
    gr = 1.2e-7
  [../]
[]

[Postprocessors]
  [./middle_temp]
    type = PointValue
    variable = temp
    point = '0 0 0'
  [../]
  [./strain]
    type = StrainRatePoint
    variable = temp
    point = '0 0 0'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 10000
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  ss_check_tol = 1e-6
  end_time = 15
  dtmax = 0.1
  scheme = bdf2
  [./TimeStepper]
    type = ConstantDT
    dt = 0.1
  [../]
[]

[Adaptivity]
  marker = efm
  max_h_level = 3
  [./Indicators]
    [./strain_indicator]
      type = GradientJumpIndicator
      variable = strain_rate
    [../]
  [../]
  [./Markers]
    [./efm]
      type = ErrorFractionMarker
      coarsen = 0.05
      indicator = strain_indicator
      refine = 0.8
    [../]
  [../]
[]

[Outputs]
  exodus = true
  console = true
[]

