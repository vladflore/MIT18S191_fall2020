using ImageView, Images, ImageFiltering, Statistics

# ==================================================================================
# Exercise 2 - Building up to dynamic programming
# ==================================================================================

random_seam(m, n, i) = reduce((a, b) -> [a..., clamp(last(a) + rand(-1:1), 1, n)], 1:m - 1; init=[i])

function greedy_seam(energies, starting_pixel::Int)
    m, n = size(energies)
    seam = zeros(Int, m)
    seam[1] = starting_pixel
    for row in 2:m
        sw = energies[row, clamp(starting_pixel - 1, 1, n)]
        s = energies[row, clamp(starting_pixel, 1, n)]
        se = energies[row, clamp(starting_pixel + 1, 1, n)]
        min, idx = findmin([sw, s, se])
		new_starting_pixel = clamp(starting_pixel + idx - 2, 1, n)
        seam[row] = new_starting_pixel
		starting_pixel = new_starting_pixel
    end
    return seam
end

function visualize_seam_algorithm(algorithm, test_img, starting_pixel)
	seam = algorithm(test_img, starting_pixel)
	
	display_img = RGB.(test_img)
	for (i, j) in enumerate(seam)
		try
			display_img[i, j] = RGB(0.9, 0.3, 0.6)
		catch ex
			if ex isa BoundsError
				return keep_working("")
			end
			# the solution might give an illegal index
		end
	end
	return display_img
end

# greedy_test = Gray.(rand(Float64, (8, 10)))
# imshow(visualize_seam_algorithm(greedy_seam, greedy_test, 1))


## returns lowest possible sum energy at pixel (i, j), and the column to jump to in row i+1.
function least_energy(energies, i, j)
    m, n = size(energies)
    if i == m
        return (energies[i,j], j)
    end
    sw_e = least_energy(energies, i + 1, clamp(j - 1, 1, n))[1]
    s_e = least_energy(energies, i + 1, j)[1]
    se_e = least_energy(energies, i + 1, clamp(j + 1, 1, n))[1]
    min_e, idx = findmin([sw_e, s_e, se_e])
    t_e = energies[i,j] + min_e

    return (t_e, clamp(j + idx - 2, 1, n))
end

function decimate(img, n)
	img[1:n:end, 1:n:end]
end

convolve(img, k) = imfilter(img, reflect(k))

brightness(c::RGB) = mean((c.r, c.g, c.b))
brightness(c::RGBA) = mean((c.r, c.g, c.b))

energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)
function energy(img)
    ∇y = convolve(brightness.(img), Kernel.sobel()[1])
    ∇x = convolve(brightness.(img), Kernel.sobel()[2])
    energy(∇x, ∇y)
end

# pika = decimate(load(download("https://art.pixilart.com/901d53bcda6b27b.png")), 150)
# pika = load(download("https://art.pixilart.com/901d53bcda6b27b.png"))

# println(energy(pika))
# println(least_energy(energy(pika), 1, 7))

# imshow(energy(pika))

function recursive_seam(energies, starting_pixel)
    m, n = size(energies)
    seam = zeros(Int, m)
    seam[1] = starting_pixel
    for i in 2:m
        seam[i] = least_energy(energies, i, seam[i - 1])[2]
    end
    return seam
end

# println(recursive_seam(energy(pika), 1))

melting = "https://cdn.shortpixel.ai/spai/w_1086+q_lossy+ret_img+to_webp/https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg"
melting_img = load(download(melting))
imshow(energy(melting_img))

# ==================================================================================
# Exercise 3 - Memoization
# ==================================================================================

function memoized_least_energy(energies, i, j, memory)
    println(memory)
    m, n = size(energies)
    if i == m
        return (energies[i,j], j)
    end

    if haskey(memory, (i, j))
        return (memory[(i, j)], j)
    else
        sw_e = memoized_least_energy(energies, i + 1, clamp(j - 1, 1, n), memory)[1]
        s_e = memoized_least_energy(energies, i + 1, j, memory)[1]
        se_e = memoized_least_energy(energies, i + 1, clamp(j + 1, 1, n), memory)[1]
        min_e, idx = findmin([sw_e, s_e, se_e])
        t_e = energies[i,j] + min_e
        memory[(i, j)] = t_e
        return (t_e, clamp(j + idx - 2, 1, n))
    end
end

function recursive_memoized_seam(energies, starting_pixel)
	memory = Dict{Tuple{Int,Int},Float64}() # location => least energy.
	                                         # pass this every time you call memoized_least_energy.
    m, n = size(energies)
    seam = zeros(Int, m)
    seam[1] = starting_pixel
    for i in 2:m
        seam[i] = memoized_least_energy(energies, i, seam[i - 1], memory)[2]
    end
    return seam
end

# fruits = load(download("https://i.imgur.com/4SRnmkj.png"))
# println("Start")
# println(recursive_memoized_seam(energy(fruits), 1))
# println("End")