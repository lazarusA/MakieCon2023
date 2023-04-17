using GLMakie, FileIO, Downloads
using YAXArrays, Zarr, NetCDF
include("utils.jl")

store ="gs://cmip6/CMIP6/ScenarioMIP/DKRZ/MPI-ESM1-2-HR/ssp585/r1i1p1f1/3hr/tas/gn/v20190710/"
g = open_dataset(zopen(store, consolidated=true))
c = g["tas"]
sub_c = c[time = (Date("2023-04-18"), Date("2023-06-30"))]
sub_c = readcubedata(sub_c) # Since is small enough, let's fetch everything into memory.

lon, lat = sub_c.lon, sub_c.lat
data = sub_c.data
d = data[:,:,1]
data_ext = ex_data(lon,lat,d) # for a closed surface
lonext = cat(collect(lon), lon[1], dims = 1)
x,y,z = getSphere(lonext, lat, data_ext; h=0,k=0,m=0)

d = Observable(data_ext .- 273.15)

fig, ax, obj=surface(x, y, z;
    color=d,
    #colormap = Reverse(:Hiroshige),
    colormap = [:snow2, :snow3, :white,  :grey50, :orange, :orangered, :orange, :yellow, :gold],
    colorrange=(-40,40),
    figure=(; resolution=(800,800), backgroundcolor=:grey10),
    axis=(; show_axis=false))
zoom!(ax.scene, cameracontrols(ax.scene), 0.65)
fig

for t in axes(data,3)
    d[] = ex_data(lon,lat,data[:,:,t]) .- 273.15
    sleep(0.01)
end
