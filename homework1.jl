using Images, FileIO

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

function gaussian_1D(x, sigma=1)
	return 1 / (2 * pi * sigma^2) * exp(-(x^2 / 2 * sigma^2))
end

function gaussian_kernel(n)
	kernel = [gaussian_1D(i) for i in -n:n]
	return kernel ./ sum(kernel)
end

# result = gaussian_kernel(1)
# sum(result)

function extend_mat(M::AbstractMatrix, i, j)
	num_rows, num_cols = size(M)
	if i in 1:num_rows && j in 1:num_cols return M[i,j] end
	if i < 1 i = 1 end
	if i > num_rows i = num_rows end
	if j < 1 j = 1 end
	if j > num_cols j = num_cols end
	return M[i,j]
end


function convolve_image(M::AbstractMatrix, K::AbstractMatrix)
	newM = copy(M)

	steps = (size(K, 1) - 1) ÷ 2
	k_row_idx = size(K, 1) ÷ 2 + 1
	k_col_idx = size(K, 2) ÷ 2 + 1

	for i in 1:size(M, 1)
		for j in 1:size(M, 2)
			s = M[i,j] * K[k_row_idx,k_col_idx]
			for step in 1:steps
				s += extend_mat(M, i, j - step) * K[k_row_idx,k_col_idx - step]
				s += extend_mat(M, i, j + step) * K[k_row_idx,k_col_idx + step]
				s += extend_mat(M, i - step, j) * K[k_row_idx - step,k_col_idx]
				s += extend_mat(M, i + step, j) * K[k_row_idx + step,k_col_idx]
				s += extend_mat(M, i - step, j - step) * K[k_row_idx - step, k_col_idx - step]
				s += extend_mat(M, i + step, j + step) * K[k_row_idx + step,k_col_idx + step]
				s += extend_mat(M, i - step, j + step) * K[k_row_idx - step,k_col_idx + step]
				s += extend_mat(M, i + step, j - step) * K[k_row_idx + step,k_col_idx - step]
			end
			newM[i,j] = s
		end
	end

	return newM
end
    

function gaussian_2D(x, y, sigma=1)
	return 1 / (2 * pi * sigma^2) * exp(-((x^2 + y^2) / 2 * sigma^2))
end

function with_gaussian_blur(image)
	n = 1
	g_k = [gaussian_2D(x, y) for x in -n:n, y in -n:n ]
	g_k = g_k ./ sum(g_k)
	return convolve_image(image, g_k)
end

# file = download("https://i.imgur.com/VGPeJ6s.jpg", "philip.jpg")
save("philip_convoluted.jpg",with_gaussian_blur(load("philip.jpg")))
# save("philip_smaller_convoluted.png",with_gaussian_blur(load("philip_smaller.png")))
# save("dog_convoluted.jpg",with_gaussian_blur(load("dog.jpg")))
