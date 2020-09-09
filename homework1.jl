function extend(v, i)
	if i in 1:length(v) return v[i] end
	if i > length(v) return v[lastindex(v)] end
	if i < 1 return v[1] end
end

function blur_1D(v, kernel)
	l = (length(kernel) - 1) ÷ 2
	box = Float64[]
	blured = Float64[]
	for idx in 1:length(v)
		for i in idx - l:idx + l
			append!(box, extend(v, i))
		end
		val = sum(kernel .* box)
		append!(blured, val)
		box = Float64[]
	end
	return blured
end

function convolve_vector(v, k)
	return blur_1D(v, k)
end

# test_convolution = let
# 	# v = [1, 10, 100, 1000, 10000]
# 	# k = [0, 1, 0]
# 	v = [1, 10, 100]
# 	k = [0, 1, 1]
# 	convolve_vector(v, k)
# end

function gaussian(x, sigma=1)
	return 1 / (2 * pi * sigma^2) * exp(-(x^2 / 2 * sigma^2))
end

function gaussian_kernel(n)
	kernel = [gaussian(i) for i in -n:n]
	return kernel ./ sum(kernel)
end

result = gaussian_kernel(1)
sum(result)
