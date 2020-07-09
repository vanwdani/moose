[Mesh]
  [./gmg]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 3
    ny = 5
    nz = 0
    xmax = 0.8
    xmin = 0.2
    zmin = 0
    zmax = 0
    elem_type = QUAD4
  []

  [./subdomain_id]
    type = ElementSubdomainIDGenerator
    input = gmg
    subdomain_ids = '0 1 2
                     0 1 2
                     0 1 2
                     0 1 2
                     0 1 2'
  []

  [./boundary01]
    type = SideSetsBetweenSubdomainsGenerator
    input = subdomain_id
    master_block = '0'
    paired_block = '1'
    new_boundary = 'boundary01'
  []

  [./boundary10]
    type = SideSetsBetweenSubdomainsGenerator
    input = boundary01
    master_block = '1'
    paired_block = '0'
    new_boundary = 'boundary10'
  []

  [./boundary12]
    type = SideSetsBetweenSubdomainsGenerator
    input = boundary10
    master_block = '1'
    paired_block = '2'
    new_boundary = 'boundary12'
  []

  [./boundary21]
    type = SideSetsBetweenSubdomainsGenerator
    input = boundary12
    master_block = '2'
    paired_block = '1'
    new_boundary = 'boundary21'
  []

  [./breakmesh]
    type = BreakMeshByBlockGenerator
    input = boundary21
  [../]

  uniform_refine = 2
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[AuxVariables]
  [./material_id]
    order = constant
    family = monomial
  [../]

  [./fromsub]
  []
[]

[BCs]
  [./left0]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]

  [./right0]
    type = DirichletBC
    variable = u
    boundary = boundary01
    value = 1
  [../]

  [./left1]
    type = DirichletBC
    variable = u
    boundary = boundary10
    value = 1
  [../]

  [./right1]
    type = DirichletBC
    variable = u
    boundary = boundary12
    value = 0
  [../]

  [./left2]
    type = DirichletBC
    variable = u
    boundary = boundary21
    value = 0
  [../]

  [./right2]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [sub]
    type = FullSolveMultiApp
    app_type = MooseTestApp
    positions = '0.0  0.0  0.0'
    execute_on = 'timestep_end'
    input_files = transfer_transformation_sub.i
  []
[]

[Transfers]
  [from_sub_gap_distance]  # plate displacement in z only
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = sub
    num_points = 1
    shrink_gap_width = 0.2
    shrink_mesh = 'source'
    source_variable = 'u'
    variable = 'fromsub'
  []

  [to_master]  # plate displacement in z only
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub
    num_points = 2
    source_variable = 'u'
    variable = 'frommaster'
  []
[]
