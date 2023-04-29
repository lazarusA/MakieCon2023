using GLMakie, FileIO, Downloads
using YAXArrays, Zarr, NetCDF
# get some data
file = "36PZQ6711.nc" # "36LYH2119.nc"
c = Cube(file)
#c = c[Variable="air_temperature_2m"]