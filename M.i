inactive = 'ICs'
[Mesh]
  type = GeneratedMesh
  block_id = '0'
  block_name = 'kernel'
  xmax = 0.0015
  ymax = 1.2
  zmax = 0.05
  dim = 3
  xmin = -0.0015
  nx = 10
  ny = 10
  zmin = -0.05
  nz = 60
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  order = 'FIRST'
  family = 'LAGRANGE'
[]

[Variables]
  inactive = 'temp'
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
  [temp]
    scaling = 1.0e-3
  []
[]

[AuxVariables]
  [strain_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [test_temp]
  []
[]

[Kernels]
  inactive = 'hc hs'
  [TensorMechanics]
    use_displaced_mesh = true
    add_variables = true
    incremental = true
  []
  [hc]
    type = HeatConduction
    variable = temp
  []
  [hs]
    type = HeatSource
    variable = temp
    value = 1.0e8
    block = 'kernel'
  []
[]

[AuxKernels]
  [strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
  []
  [strain_yy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yy
    index_i = 1
    index_j = 1
  []
  [strain_zz]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_zz
    index_i = 2
    index_j = 2
  []
  [test_temo]
    type = ConstantAux
    value = 300.0
    variable = test_temp
    block = 'kernel'
  []
[]

[BCs]
  inactive = 'left_bcs right_bcs'
  [left_bcs]
    type = PresetBC
    variable = temp
    boundary = 'left'
    value = 600
  []
  [right_bcs]
    type = FunctionPresetBC
    variable = temp
    boundary = 'right left'
    function = ic
  []
  [x_bot]
    type = PresetBC
    variable = disp_x
    boundary = 'bottom'
    value = 0.0
  []
  [y_bot]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  []
  [z_bot]
    type = PresetBC
    variable = disp_z
    boundary = 'bottom'
    value = 0.0
  []
[]

[Materials]
  inactive = 'hcm'
  [hcm]
    type = HeatConductionMaterial
    block = 'kernel'
    thermal_conductivity = 4.0
  []
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    block = 'kernel'
    youngs_modulus = 2.1e11
    poissons_ratio = 0.345
  []
  [small_strain]
    type = ComputeSmallStrain
    eigenstrain_names = 'eigenstrain1'
    block = 'kernel'
  []
  [small_stress]
    type = ComputeLinearElasticStress
    block = 'kernel'
  []
  [thermal_expansion_strain1]
    type = ComputeThermalExpansionEigenstrain
    block = 'kernel'
    stress_free_temperature = '298'
    thermal_expansion_coeff = 1.0e-6
    temperature = 'test_temp'
    incremental_form = true
    eigenstrain_name = eigenstrain1
  []
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_abs_tol = 1e-7
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
  line_search = none
  petsc_options = '-snes_mf_operator -ksp_monitor'
  l_max_its = 50
  petsc_options_value = 'hypre boomeramg 0.7'
  l_tol = 1e-9
  solve_type = PJFNK
  end_time = 10
  nl_rel_tol = 1e-07
[]

[Outputs]
  csv = true
  exodus = true
  checkpoint = true
  file_base = p20_300
  print_linear_residuals = false
[]

[Postprocessors]
  inactive = 'fuel_Tmax'
  [fuel_Tmax]
    type = NodalExtremeValue
    variable = 'temp'
    block = 'kernel'
  []
  [run_time]
    type = PerformanceData
    event = ALIVE
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    line_search = 'none'
    full = true
  []
[]

[Debug]
  show_var_residual = 'disp_x disp_y disp_z'
  show_var_residual_norms = true
[]

[Functions]
  [ic]
    type = ParsedFunction
    value = '302/10*t+298.0'
  []
  [hs]
    type = ParsedFunction
    value = '1.0e7*t'
  []
[]

[ICs]
  [temp]
    type = FunctionIC
    function = ic
    variable = temp
    block = 'kernel'
  []
[]
