using ImageView, Images

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

greedy_test = Gray.(rand(Float64, (8, 10)))
imshow(visualize_seam_algorithm(greedy_seam, greedy_test, 1))