# Various code snippets for plotting

# letter_counts = countmap(test_text)
# for key in qwerty
#     if ~haskey(letter_counts, key)
#         letter_counts[key] = 0
#     end
# end

# dvorak_cost = dot(w, [f(dvorak, keyxy, test_text) for f in [total_dist total_effort]])
# dvorak_cost = trunc(Int, round(dvorak_cost; digits=0))

# colemak_cost = dot(w, [f(colemak, keyxy, test_text) for f in [total_dist total_effort]])
# colemak_cost = trunc(Int, round(colemak_cost; digits=0))

# workman_cost = dot(w, [f(workman, keyxy, test_text) for f in [total_dist total_effort]])
# workman_cost = trunc(Int, round(workman_cost; digits=0))


# keymap_viz = plot()

# qwerty_colors = [letter_counts[c] for c in qwerty]
# best_keymap_colors = [letter_counts[c] for c in best_keymap]
# 
# savefig(keymap_viz,"corpus.pdf")

# println("QWERTY: ",qwerty_cost)
# println("Dvorak: ",dvorak_cost)
# println("Colemak: ",colemak_cost)
# println("Workman: ",workman_cost)
# println("Optimized: ",cost)

# qwerty_dists = dists = total_key_dist(qwerty, keyxy, test_text) + total_key_effort(qwerty, keyxy, test_text)
# dists = total_key_dist(best_keymap, keyxy, test_text) + total_key_effort(best_keymap, keyxy, test_text)

# ms = 13
# keymap_heatmap = plot(layout=grid(1, 2))
# keymap_heatmap = scatter!(keyx, keyy, marker=:square,
#                             marker_z=qwerty_dists,
#                             markersize=ms,
#                             series_annotations=[c for c in qwerty],
#                             c=:bilbao,
#                             legend=false,
#                             colorbar=true,
#                             aspect_ratio=:equal,
#                             axis=([], false),
#                             xlim=[-1, 11],
#                             ticks=false,
#                             grid=false,
#                             subplot=1
#                             )
# keymap_heatmap = scatter!(keyx, keyy, marker=:square,
#                     marker_z=dists,
#                     markersize=ms,
#                     series_annotations=[c for c in best_keymap],
#                     c=:bilbao,
#                      legend=false,
#                      aspect_ratio=:equal,
#                      axis=([], false),
#                      xlim=[-1, 11],
#                      ticks=false,
#                      grid=false,
#                      subplot=2)
# plot!(keymap_heatmap,size=(1000, 250))
# display(keymap_heatmap)

# Visualize keymaps
# keymap_viz = plot(layout=grid(2, 2))
# efforts = vec([2 1 1 1 1.5 1.5 1 1 1 2 0.75 0.5 0 0 1 1 0 0 0.5 0.75 1 1 1 1 1 2 2 1 1 1 1 0])
# keymap_viz = 
# keymap_viz = scatter!(keyx, keyy, marker=:square, markercolor=finger, markersize=18, series_annotations=[c for c in best_keymap], legend=false, aspect_ratio=:equal, axis=([], false), xlim=[-1, 11], ticks=false, grid=false, subplot=2, title="Dvorak")
# scatter!(keymap_viz,size=(1000, 500))
# plot!(plt,size=(1000, 1000))
# display(keymap_viz)
# savefig(keymap_viz,"keymaps.pdf")

# Visualize keymaps
# keymap_viz = plot(layout=grid(2, 2))
# efforts = vec([2 1 1 1 1.5 1.5 1 1 1 2 0.75 0.5 0 0 1 1 0 0 0.5 0.75 1 1 1 1 1 2 2 1 1 1 1 0])
# keymap_viz = scatter!(keyx, keyy, marker=:square, markercolor=finger, markersize=18, series_annotations=[c for c in qwerty], legend=false, aspect_ratio=:equal, axis=([], false), xlim=[-1, 11], ticks=false, grid=false, subplot=1, title="QWERTY")
# keymap_viz = scatter!(keyx, keyy, marker=:square, markercolor=finger, markersize=18, series_annotations=[c for c in dvorak], legend=false, aspect_ratio=:equal, axis=([], false), xlim=[-1, 11], ticks=false, grid=false, subplot=2, title="Dvorak")
# keymap_viz = scatter!(keyx, keyy, marker=:square, markercolor=finger, markersize=18, series_annotations=[c for c in colemak], legend=false, aspect_ratio=:equal, axis=([], false), xlim=[-1, 11], ticks=false, grid=false, subplot=3, title="Colemak")
# keymap_viz = scatter!(keyx, keyy, marker=:square, markercolor=finger, markersize=18, series_annotations=[c for c in workman], legend=false, aspect_ratio=:equal, axis=([], false), xlim=[-1, 11], ticks=false, grid=false, subplot=4, title="Workman")
# scatter!(keymap_viz,size=(1000, 500))
# plot!(plt,size=(1000, 1000))
# display(keymap_viz)
# savefig(keymap_viz,"keymaps.pdf")
# end
 
# print_keymap(keymaps[sortperm(costs)[1]])

# display(histogram(cost_histories[end,:], bins=:scott))
# B = kde(cost_histories[end,:])
# display(plot(B.x, B.density))
# savefig(plt,"sacosthistory151000.pdf")

# savefig(keymap_viz,"sa2.pdf")