[MeshGenerators]
  [read]
    type = FileMeshGenerator
    file = twoblocks.e
  []
  [block_1]
    type = AllSideSetsByNormalsGenerator
    input = read
  []
[]

[Mesh]
  type = MeshGeneratorMesh
[]

# This input file is intended to be run with the "--mesh-only" option so
# no other sections are required
