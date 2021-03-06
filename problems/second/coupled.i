[Mesh]
  type = FileMesh
  file = ../second/cascadia_simple2.e
[]

[Variables]
  active = 'temp disp_x disp_y'
  [./pressure]
  [../]
  [./temp]
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[Kernels]
  active = 'td_temp diff_temp mht_temp'
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
    ar = 5
    block = subduction_zone
  [../]
  [./td_pres]
    type = TimeDerivative
    variable = pressure
  [../]
  [./mht_temp]
    type = MechHeatTensor
    variable = temp
    ar = 5
    block = subduction_zone
    gr = 1e-9
  [../]
[]

[BCs]
  [./surface_temp]
    type = DirichletBC
    variable = temp
    boundary = surface
    value = 0
  [../]
  [./surface_hold_x]
    type = DirichletBC
    variable = disp_x
    boundary = surface
    value = 0
  [../]
  [./surface_hold_y]
    type = DirichletBC
    variable = disp_y
    boundary = surface
    value = 0
  [../]
  [./bottom_stress]
    type = NeumannBC
    variable = disp_x
    boundary = lower_mantle
    value = 1
  [../]
  [./bottom_fix_y]
    type = DirichletBC
    variable = disp_y
    boundary = lower_mantle
    value = 0
  [../]
[]

[Materials]
  [./linear_el_mat]
    type = LinearElasticMaterial
    block = 'crust mantle subduction_zone'
    disp_y = disp_y
    disp_x = disp_x
    C_ijkl = '5e9 0 1e9 2e9 0 0 1e9 0 5e9'
    all_21 = false
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1
  dt = 1e-5
  l_max_its = 100
  nl_max_its = 10
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  active = ''
  exodus = true
  console = true
  print_linear_residuals = true
  [./console]
    type = Console
    perf_log = true
  [../]
[]

[ICs]
  [./ic_temp]
    variable = temp
    type = ConstantIC
    value = 0
  [../]
[]

[TensorMechanics]
  [./tensor_mech]
    disp_y = disp_y
    disp_x = disp_x
  [../]
[]

