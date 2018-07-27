[Mesh]
  type = GeneratedMesh
  block_id = '0'
  block_name = 'kernel'
  zmax = 0.05
  zmin = -0.05
  xmin = -1.5e-3
  ymax = 1.2
  nx = 10
  ny = 10
  nz = 60
  dim = 3
  xmax = 1.5e-3
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  order = 'FIRST'
  family = 'LAGRANGE'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
  [temp]
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
[]

[Kernels]
  [TensorMechanics]
    use_displaced_mesh = true
    temperature = temp
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
[]

[BCs]
  [left_bcs]
    type = PresetBC
    variable = temp
    boundary = 'left'
    value = 600
  []
  [right_bcs]
    type = PresetBC
    variable = temp
    boundary = 'right'
    value = 600
  []
  [x_bot]
    type = DirichletBC
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
    type = ComputeIncrementalSmallStrain
    block = 'kernel'
    eigenstrain_names = 'eigenstrain1'
  []
  [small_stress]
    type = ComputeFiniteStrainElasticStress
    block = 'kernel'
  []
  [thermal_expansion_strain1]
    type = ComputeThermalExpansionEigenstrain
    block = 'kernel'
    stress_free_temperature = '298'
    thermal_expansion_coeff = 1.0e-5
    temperature = 'temp'
    incremental_form = true
    eigenstrain_name = eigenstrain1
  []
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Steady
  solve_type = PJFNK
  line_search = none
  l_max_its = 50
  petsc_options = '-snes_mf_operator -ksp_monitor'
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 0.7'
  nl_abs_tol = 1e-10
  l_tol = 1e-9
[]

[Outputs]
  csv = true
  exodus = true
  checkpoint = true
  file_base = p20_300
  print_linear_residuals = false
[]

[Postprocessors]
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
  show_var_residual = 'disp_x disp_y disp_z temp'
  show_var_residual_norms = true
[]
