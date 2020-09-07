### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# ╔═╡ c8afffda-f10b-11ea-22a3-45cf27990bf6
begin
	using Statistics
	using Images
	using FFTW
	using Plots
	using DSP
	using ImageFiltering
	using PlutoUI
end

# ╔═╡ 84dffc9e-f10b-11ea-01c4-f33c12450dfa
begin
	large_image=load("dog.jpg")
end

# ╔═╡ 740a5e20-f10c-11ea-1a60-41a6465a3b2e
function show_colored_kernel(kernel)
	to_rgb(x) = RGB(max(-x,0), max(x,0), 0)
	to_rgb.(kernel) / maximum(abs.(kernel))
end

# ╔═╡ 2cf7df3a-f10c-11ea-3526-557b908c6a0e
begin
	kernel = Kernel.gaussian((1,1))
	kernel
# 	show_colored_kernel(kernel)
end

# ╔═╡ 3429a536-f137-11ea-1a27-17c5ed82f239
kernel[0,0]

# ╔═╡ Cell order:
# ╠═c8afffda-f10b-11ea-22a3-45cf27990bf6
# ╠═84dffc9e-f10b-11ea-01c4-f33c12450dfa
# ╠═740a5e20-f10c-11ea-1a60-41a6465a3b2e
# ╠═2cf7df3a-f10c-11ea-3526-557b908c6a0e
# ╠═3429a536-f137-11ea-1a27-17c5ed82f239
