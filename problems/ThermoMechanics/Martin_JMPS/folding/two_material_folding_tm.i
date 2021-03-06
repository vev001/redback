[Mesh]
  # created from meshes/2d_3layers.geo
  type = FileMesh
  file = ../../../../meshes/2d_3layers.msh
[]

[MeshModifiers]
  [./right_middle]
    type = AddExtraNodeset
    new_boundary = 4
    coord = '5 0'
  [../]
  [./left_middle]
    type = AddExtraNodeset
    new_boundary = 5
    coord = '-5 0'
  [../]
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
  [../]
[]

[Materials]
  [./mat0]
    type = RedbackMechMaterialJ2
    block = '0 2'
    disp_y = disp_y
    disp_x = disp_x
    yield_stress = '0. 1 1. 1'
    disp_z = disp_z
    alpha_2 = 3
    ar = 10
    gr = 0.3
    is_mechanics_on = false
    exponent = 1
    ref_lewis_nb = 1
    ar_F = 20
    ar_R = 10
    phi0 = 0.1
    ref_pe_rate = 1
    Aphi = 0
    slope_yield_surface = -0.6
    temperature = temp
    is_chemistry_on = true
    fluid_thermal_expansion = 1e-5
    solid_thermal_expansion = 0
    poisson_ratio = 0.3
    youngs_modulus = 10
  [../]
  [./mat1]
    type = RedbackMechMaterialJ2
    block = 1
    disp_y = disp_y
    disp_x = disp_x
    yield_stress = '0. 1 1e-6 0.8 1 0.8'
    disp_z = disp_z
    alpha_2 = 3
    ar = 10
    gr = 3
    is_mechanics_on = false
    exponent = 1
    ref_lewis_nb = 1
    ar_F = 20
    ar_R = 10
    phi0 = 0.1
    ref_pe_rate = 1
    Aphi = 0
    slope_yield_surface = -0.6
    temperature = temp
    is_chemistry_on = true
    fluid_thermal_expansion = 1e-5
    solid_thermal_expansion = 0
    poisson_ratio = 0.3
    youngs_modulus = 100
  [../]
  [./mat_noMech]
    type = RedbackMaterial
    block = '0 2 1'
    ref_lewis_nb = 1
    ar_F = 20
    disp_x = disp_x
    alpha_2 = 3
    disp_y = disp_y
    ar_R = 10
    ar = 10
    Aphi = 0
    temperature = temp
    gr = 0.3
    disp_z = disp_z
  [../]
[]

[Functions]
  active = 'upfunc downfunc'
  [./upfunc]
    type = ParsedFunction
    value = 0.1*t
  [../]
  [./downfunc]
    type = ParsedFunction
    value = -0.1*t
  [../]
  [./spline_IC]
    type = ConstantFunction
  [../]
[]

[BCs]
  active = 'constant_velocity_left temp_box left_disp_y const_vel_right_disp_x rigth_disp_y'
  [./bottom_temp]
    type = NeumannBC
    variable = temp
    boundary = 0
    value = -1
  [../]
  [./top_temp]
    type = NeumannBC
    variable = temp
    boundary = 2
    value = -1
  [../]
  [./left_disp_y]
    type = DirichletBC
    variable = disp_y
    boundary = 5
    value = 0
  [../]
  [./temp_mid_pts]
    type = DirichletBC
    variable = temp
    boundary = 4
    value = 0
  [../]
  [./rigth_disp_y]
    type = DirichletBC
    variable = disp_y
    boundary = 4
    value = 0
  [../]
  [./temp_box]
    type = DirichletBC
    variable = temp
    boundary = '0 2'
    value = 0
  [../]
  [./constant_force_right]
    type = NeumannBC
    variable = disp_x
    boundary = 1
    value = -2
  [../]
  [./const_vel_right_disp_x]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 1
    function = downfunc
  [../]
  [./constant_velocity_left]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 3
    function = upfunc
  [../]
[]

[AuxVariables]
  active = 'Mod_Gruntfest_number mises_strain mech_diss mises_strain_rate volumetric_strain_rate mises_stress volumetric_strain mean_stress'
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./peeq]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe33]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mises_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mises_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mises_strain_rate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mech_diss]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Mod_Gruntfest_number]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./volumetric_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./volumetric_strain_rate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mean_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  active = 'temp_diff td_temp temp_dissip'
  [./td_temp]
    type = TimeDerivative
    variable = temp
  [../]
  [./temp_diff]
    type = Diffusion
    variable = temp
  [../]
  [./temp_dissip]
    type = RedbackMechDissip
    variable = temp
  [../]
  [./chem_endo_temperature]
    type = RedbackChemEndo
    variable = temp
  [../]
[]

[AuxKernels]
  active = 'volumetric_strain mises_strain mises_strain_rate volumetric_strain_rate mises_stress mean_stress mech_dissipation Gruntfest_Number'
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./pe11]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe11
    index_i = 0
    index_j = 0
  [../]
  [./pe22]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe22
    index_i = 1
    index_j = 1
  [../]
  [./pe33]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe33
    index_i = 2
    index_j = 2
  [../]
  [./eqv_plastic_strain]
    type = FiniteStrainPlasticAux
    variable = peeq
  [../]
  [./mises_stress]
    type = MaterialRealAux
    variable = mises_stress
    property = mises_stress
  [../]
  [./mises_strain]
    type = MaterialRealAux
    variable = mises_strain
    property = eqv_plastic_strain
  [../]
  [./mises_strain_rate]
    type = MaterialRealAux
    variable = mises_strain_rate
    property = mises_strain_rate
  [../]
  [./mech_dissipation]
    type = MaterialRealAux
    variable = mech_diss
    property = mechanical_dissipation
  [../]
  [./Gruntfest_Number]
    type = MaterialRealAux
    variable = Mod_Gruntfest_number
    property = mod_gruntfest_number
  [../]
  [./mean_stress]
    type = MaterialRealAux
    variable = mean_stress
    property = mean_stress
  [../]
  [./volumetric_strain]
    type = MaterialRealAux
    variable = volumetric_strain
    property = volumetric_strain
  [../]
  [./volumetric_strain_rate]
    type = MaterialRealAux
    variable = volumetric_strain_rate
    property = volumetric_strain_rate
  [../]
[]

[Postprocessors]
  [./mises_stress]
    type = PointValue
    variable = mises_stress
    point = '0 0 0'
  [../]
  [./mises_strain]
    type = PointValue
    variable = mises_strain
    point = '0 0 0'
  [../]
  [./mises_strain_rate]
    type = PointValue
    variable = mises_strain_rate
    point = '0 0 0'
  [../]
  [./temp_middle]
    type = PointValue
    variable = temp
    point = '0 0 0'
  [../]
  [./mean_stress]
    type = PointValue
    variable = mean_stress
    point = '0 0 0'
  [../]
  [./volumetric_strain]
    type = PointValue
    variable = volumetric_strain
    point = '0 0 0'
  [../]
  [./volumetric_strain_rate]
    type = PointValue
    variable = volumetric_strain_rate
    point = '0 0 0'
  [../]
[]

[Preconditioning]
  # active = ''
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  start_time = 0.0
  end_time = 10
  dtmax = 1
  dtmin = 1e-7
  num_steps = 10000
  type = Transient
  l_max_its = 200
  nl_max_its = 10
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -snes_linesearch_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg cp 201'
  nl_abs_tol = 1e-10 # 1e-10 to begin with
  reset_dt = true
  line_search = basic
  [./TimeStepper]
    type = ConstantDT
    dt = 5e-4
  [../]
[]

[Outputs]
  output_initial = true
  exodus = true
  csv = true
  [./console]
    type = Console
    perf_log = true
    output_linear = false
  [../]
[]

[RedbackMechAction]
  [./solid]
    disp_z = disp_z
    disp_y = disp_y
    disp_x = disp_x
    temp = temp
  [../]
[]

[ICs]
  [./temp_IC]
    variable = temp
    type = RandomIC
  [../]
[]

