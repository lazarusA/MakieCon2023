using AlgebraOfGraphics, CairoMakie
x = [-3:6]
y = [-3:6]
#z = reshape([rand(10, 10), rand(10, 10), rand(10, 10), rand(10, 10)], 2, 2)

z = [rand(10, 10), rand(10, 10)]

plt = mapping(z, col=["1","2"]) * visual(Heatmap)
draw(plt)

plt = mapping(x => "X", y => "Y", z, col=["1","2"]) * visual(Heatmap)
draw(plt)

plt = mapping(x => "X", y => "Y", z, col=["1","2"], row=["col1" "col2"]) * visual(Contour)
draw(plt)
