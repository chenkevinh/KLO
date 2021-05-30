using Plots, Plots.PlotMeasures
using LinearAlgebra
using Random
using Distributions
using Hungarian
using StatsBase
using PrettyTables
using KernelDensity

include("keys.jl")
include("text_gen.jl")
include("schedules.jl")
include("helpers.jl")
include("costfuncs.jl")

# Define QWERTY default keymap and other alternative layouts
qwerty = "qwertyuiopasdfghjkl;'zxcvbnm,./ "
dvorak = "',.pyfgcrlaoeuidhtns-;qjkxbmwvz "
colemak = "qwfpgjluy;arstdhneio'zxcvbkm,./ "
workman = "qdrwbjfup;ashtgyneoi'zxmcvkl,./ "
keymap = qwerty

# Define geometrical layout of keymap
numkeys = length(keymap)
numkeysrow = [10 11 10 1]
rowoffsets = [0 0.25 0.75 5]

# Calculate (x,y) positions of keys using top left as (0,0)
keyx = []
keyy = []
numrows = length(numkeysrow)
for i = 1:numrows
    global keyx = [keyx; (0:numkeysrow[i] - 1) .+ rowoffsets[i]]
    global keyy = [keyy; -(i - 1) .* ones(numkeysrow[i], 1)]
end
keyx = vec(keyx)
keyy = vec(keyy)
keyxy = [[keyx[i],keyy[i]] for i in 1:length(keyx)]

# Assign fingers to keys
finger = vec([1 2 3 4 4 7 7 8 9 10 1 2 3 4 4 7 7 8 9 10 10 1 2 3 4 4 7 7 8 9 10 6])
homerow = [11 12 13 14 17 18 19 20 32]
homerow_finger = [1 2 3 4 7 8 9 10 6]

# Create test_text from word frequency tables
words = readdlm("words/unigram_freq.csv", ',';header=true)
words = words[1]
words = [words[:,i] for i in 1:size(words, 2)]
counts = words[2]
words = words[1]
wv = counts ./ sum(counts)
words = words[1:50000]
wv = wv[1:50000]

# Choose between corpus-derived test text or Tom Sawyer
# test_text = generate_text(words, wv, 50000)
test_text = lowercase(read("words/tom_sawyer.txt", String))

# Specify weighting for finger travel and finger effort
weight = [1 1]

# Compute costs for QWERTY
qwerty_cost = dot(weight, [f(qwerty, keyxy, test_text) for f in [total_dist total_effort]])
qwerty_cost = trunc(Int, round(qwerty_cost; digits=0))

# Use Hungarian method to solve and obtain cost
best_keymap, cost = optimize(qwerty, test_text, [total_distance_cost total_effort_cost], weight)
cost = trunc(Int, round(cost; digits=0))

# Generate QWERTY and optimized layout graphics
ms = 18
keymap_viz = plot(layout=grid(1, 2))
keymap_viz = scatter!(keyx, keyy, marker=:square,
                     markercolor=finger,
                     markersize=ms,
                     series_annotations=[c for c in qwerty],
                     legend=false,
                     aspect_ratio=:equal,
                     axis=([], false),
                     xlim=[-1, 11],
                     ticks=false,
                     grid=false,
                     title=string("Total Effort: ", qwerty_cost),
                     subplot=1)
keymap_viz = scatter!(keyx, keyy, marker=:square,
                     markercolor=finger,
                     markersize=ms,
                     series_annotations=[c for c in best_keymap],
                     legend=false,
                     aspect_ratio=:equal,
                     axis=([], false),
                     xlim=[-1, 11],
                     ticks=false,
                     grid=false,
                     title=string("Total Effort: ", cost),
                     subplot=2)
plot!(keymap_viz,size=(1000, 250))
display(keymap_viz)

# Solve using simulated annealing
loops = 1
k_max = 500
keymaps =  Array{String}(undef, 1, loops)
costs = Any[]
cost_histories = zeros(k_max + 1, loops)
labels =  Array{String}(undef, 1, loops)
for i = 1:loops
    local keymap, cost, cost_history = simulated_annealing([total_dist total_effort], weight, keyxy, test_text, qwerty, exponential, 1 / 2, k_max)
    global keymaps[i] = keymap
    global costs = [costs; cost]
    global cost_histories[:,i] = cost_history
    global labels[i] = string(keymap, " | ", trunc(Int, round(cost)))
end

# Plot iteration history
plt = plot(cost_histories, label=labels, xlabel="Iteration", ylabel="Typing Effort")
display(plt)

# Generate QWERTY and optimized layout graphics
ms = 18
keymap_viz = plot(layout=grid(1, 2))
keymap_viz = scatter!(keyx, keyy, marker=:square,
                     markercolor=finger,
                     markersize=ms,
                     series_annotations=[c for c in qwerty],
                     legend=false,
                     aspect_ratio=:equal,
                     axis=([], false),
                     xlim=[-1, 11],
                     ticks=false,
                     grid=false,
                     title=string("Total Effort: ", trunc(Int, round(cost_histories[1,1], digits=0))),
                     subplot=1)
keymap_viz = scatter!(keyx, keyy, marker=:square,
                     markercolor=finger,
                     markersize=ms,
                     series_annotations=[c for c in keymaps[1]],
                     legend=false,
                     aspect_ratio=:equal,
                     axis=([], false),
                     xlim=[-1, 11],
                     ticks=false,
                     grid=false,
                     title=string("Total Effort: ", trunc(Int, round(cost_histories[end,1]))),
                     subplot=2)
plot!(keymap_viz,size=(1000, 250))
display(keymap_viz)
