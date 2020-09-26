### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ e69f0448-f104-11ea-0595-17ce3f5f13d8
using Images

# ╔═╡ 87a86b28-f104-11ea-24c2-b103df778b96
url="https://i.ytimg.com/vi/MPV2METPeJU/maxresdefault.jpg"

# ╔═╡ d2078c26-f104-11ea-2cfc-13dd28665c28
download(url,"dog.jpg")

# ╔═╡ 666f6528-f105-11ea-20f9-21a3c01c4646
begin
	dog=load("dog.jpg")
	dog
	typeof(dog)
	size(dog)
end

# ╔═╡ e29076ec-f105-11ea-19fa-4f553e1f8a30
RGBX(0.8,0.2,0.1)

# ╔═╡ 027fe47e-f106-11ea-37e0-3dc7b8053981
typeof(dog[100,400])

# ╔═╡ 1df65b3e-f106-11ea-2063-05b95cb3856e
typeof(dog[1:300,1:300])

# ╔═╡ 8993d0d6-f106-11ea-2c31-291a3a0c4ff8
[dog dog]

# ╔═╡ a1ecc05e-f106-11ea-0921-c9918cfd10c1
[
	dog 				reverse(dog,dims=2)
	reverse(dog,dims=1) reverse(reverse(dog,dims=1), dims=2)
]

# ╔═╡ 2db4426a-f107-11ea-091d-c94c3c9ee8b8
begin
	new_dog=copy(dog)
	clr_red = RGB(1,0,0)
	for i in 1:100
		for j in 1:200
			new_dog[i,j] = clr_red
		end
	end
	new_dog
	dog2=copy(dog)
	clr_green = RGB(0,1,0)
	# an example of broadcasting
	dog2[1:100,1:200] .= clr_green
	dog2
end

# ╔═╡ 2b214c72-f108-11ea-38b9-75c99d02ba98
function redify(color)
	return RGB(color.r,0,0)
end

# ╔═╡ 3b0f8470-f108-11ea-00e8-254e05568541
begin
	color = RGB(0.8,0.5,0.2)
	[color, redify(color)]
end

# ╔═╡ 7c825b38-f108-11ea-211a-2705a344b986
redify.(copy(dog))

# ╔═╡ f31642c8-f108-11ea-397a-45c024ca7559
blur(2)

# ╔═╡ 4d62c8b2-f109-11ea-375f-955da59674ec
function decimate(arr,ratio=5)
	return arr[1:ratio:end, 1:ratio:end]
end

# ╔═╡ 2d6f727c-f10a-11ea-1ab6-87a617ab1364
@bind decimate_ratio Slider(1:20, show_value=true)

# ╔═╡ 872a4d6e-f10a-11ea-0fac-931a6486cd5d
begin
	poor_dog=decimate(dog,decimate_ratio)
# 	size(poor_dog)
	poor_dog
end

# ╔═╡ Cell order:
# ╠═87a86b28-f104-11ea-24c2-b103df778b96
# ╠═d2078c26-f104-11ea-2cfc-13dd28665c28
# ╠═e69f0448-f104-11ea-0595-17ce3f5f13d8
# ╠═666f6528-f105-11ea-20f9-21a3c01c4646
# ╠═e29076ec-f105-11ea-19fa-4f553e1f8a30
# ╠═027fe47e-f106-11ea-37e0-3dc7b8053981
# ╠═1df65b3e-f106-11ea-2063-05b95cb3856e
# ╠═8993d0d6-f106-11ea-2c31-291a3a0c4ff8
# ╠═a1ecc05e-f106-11ea-0921-c9918cfd10c1
# ╠═2db4426a-f107-11ea-091d-c94c3c9ee8b8
# ╠═2b214c72-f108-11ea-38b9-75c99d02ba98
# ╠═3b0f8470-f108-11ea-00e8-254e05568541
# ╠═7c825b38-f108-11ea-211a-2705a344b986
# ╠═f31642c8-f108-11ea-397a-45c024ca7559
# ╠═4d62c8b2-f109-11ea-375f-955da59674ec
# ╠═2d6f727c-f10a-11ea-1ab6-87a617ab1364
# ╠═872a4d6e-f10a-11ea-0fac-931a6486cd5d
