[MeshGenerators]
  [./gmg]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 4
    ny = 4
    nz = 4
    elem_type = TET4
  []

  [./left_block]
    type = SubdomainBoundingBoxGenerator
    input = gmg
    block_id = 1
    block_name = left_block
    bottom_left = '0 0 0'
    top_right = '0.5 1 1'
  []

  [./right_block]
    type = SubdomainBoundingBoxGenerator
    input = left_block
    block_id = 2
    block_name = right_block
    bottom_left = '0.5 0 0'
    top_right = '1 1 1'
  []

  [./center_side_set]
    type = SideSetsBetweenSubdomainsGenerator
    input = right_block
    master_block = left_block
    paired_block = right_block
    new_boundary = center_side_set
  []

  [./center_mesh]
    type = MeshSideSetGenerator
    input = center_side_set
    boundaries = center_side_set
    block_id = 10
    block_name = center_mesh
  []
[]

[Mesh]
  type = MeshGeneratorMesh
[]

[Variables]
  [./c_volume]
    [./InitialCondition]
      type = FunctionIC
      function = '1-(x-0.5)^2+(y-0.5)^2+(z-0.5)^2'
    [../]
  [../]
  [./c_plane]
    block = 'center_mesh'
  [../]
[]

[Kernels]
  [./volume_diff]
    type = Diffusion
    variable = c_volume
    block = 'left_block right_block'
  [../]
  [./volume_dt]
    type = TimeDerivative
    variable = c_volume
    block = 'left_block right_block'
  [../]

  # couple the lower dimensional variable to the volume variable
  [./plane_reaction]
    type = Reaction
    variable = c_plane
    block = 'center_mesh'
  [../]
  [./plane_coupled]
    type = CoupledForce
    variable = c_plane
    v = c_volume
    block = 'center_mesh'
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.01
  num_steps = 2
[]

[Outputs]
  exodus = true
[]
