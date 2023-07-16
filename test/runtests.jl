# test/runtests.jl

using Aqua
using ToponymAt
using Test

Aqua.test_all(ToponymAt)

@testset "toponomina" begin
	@test toponomina(116, 40) == "北京市北京城区门头沟区妙峰山镇"
	@test toponomina(114, 23) == "广东省东莞市常平镇"
end
