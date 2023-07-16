# ToponymAt.jl

module ToponymAt

using GeoJSON
using PolygonOps

export toponomina

dir = ENV["TOPONYM_PATH"]
files = readdir(dir)
files_root = files[occursin.("0000.", files)]

pip(x::Number, y::Number, pp) =
	any(xor([PolygonOps.inpolygon([x, y], c__) .!= 0
		for c__ = c_]...) for c_ = pp.coordinates)

function find(x::Number, y::Number, file::String)
	path = joinpath(dir, file)
	for f = GeoJSON.read(read(path)[4:end]).features
		pip(x, y, f.geometry) && return f.properties
	end
end

function findchild(x::Number, y::Number, file::String)
	r = find(x, y, file)
	isnothing(r) && return ""
	r[:name] * (r[:level] == "street" ? "" : 
		findchild(x, y, "$(r[:name])_$(r[:id]).geojson"))
end

function toponomina(x::Number, y::Number)
	for file = files_root
		t = findchild(x, y, file)
		t != "" && return split(file, '_')[1] * t
	end
end

end # module ToponymAt
