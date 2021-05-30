function optimize(keymap, test_text, costfunc, weights)
    km_costs = zeros(length(keymap), length(keymap))
    i = 1
    for f in costfunc
        km_costs = km_costs + weights[i] * f(keymap, test_text)
        i += 1
    end
    assignment, cost = hungarian(km_costs)

    return keymap[sortperm(assignment)], cost
end

function simulated_annealing(costfuncs, weights, keyxy, test_text, x, t, k, k_max)
    y = dot(weights, [f(x, keyxy, test_text) for f in costfuncs])
    x_best, y_best = x, y
    y_history = zeros(k_max + 1, 1)
    y_history[1] = y_best
    for k in 1:k_max
        x′ = new_keymap(x, 2)
        y′ = dot(weights, [f(x′, keyxy, test_text) for f in costfuncs])
        Δy = y′ - y
        if Δy ≤ 0 || rand() < exp(-Δy / t(k))
            x, y = x′, y′
        end
        if y′ < y_best
            x_best, y_best = x′, y′
        end
        y_history[k + 1] = y_best
    end
    return x_best, y_best, y_history
end

function print_keymap(keymap)
    row1 = keymap[1:10]
    row2 = keymap[11:21]
    row3 = keymap[22:31]
    row4 = keymap[32]
    print(join(row1, " "), "\n ", join(row2, " "), "\n  ", join(row3, " "), "\n          ", join(row4, " "), "\n")
end

function generate_keymap()
    qwerty = "qwertyuiopasdfghjkl;'zxcvbnm,./ "
    random_keymap = randperm(length(qwerty))
    return qwerty[random_keymap]
end

function new_keymap(keymap, numswaps)
    swap = randperm(length(keymap))[1:2 * numswaps]
    keys = [keymap[i] for i in swap]
    key_swap = Dict([keys[1:numswaps] keys[numswaps + 1:end]] .=> [keys[numswaps + 1:end] keys[1:numswaps]])
    new_map = ""
    for c in keymap
        if c in keys
            new_map = string(new_map, key_swap[c])
        else
            new_map = string(new_map, c)
        end
    end
    return new_map
end