function key_dist(key, keymap, keyxy)
    if typeof(key) == Int
        if (key ∈ homerow)
            return 0
        else
            key_i = key
        end
    else 
        if (key == " ")
            return 0
        else
            key_i = findnext(isequal(key), keymap, 1)
            if key_i === nothing
                return 0
            end
        end
    end

    key_finger = finger[key_i]
    homerow_key_i = homerow[findfirst(isequal(key_finger), homerow_finger)]
    key_pos = keyxy[key_i]
    homerow_key_pos = keyxy[homerow_key_i]
    return norm(key_pos - homerow_key_pos)
end

function key_effort(key, keymap)
    if typeof(key) == Int
        key_i = key
    else
        key_i = findnext(isequal(key), keymap, 1)
    end
    efforts = vec([2 1 1 1 1.5 1.5 1 1 1 2 0.75 0.5 0 0 1 1 0 0 0.5 0.75 1 1 1 1 1 2 2 1 1 1 1 0])
    return efforts[key_i]
end

function total_dist_iter(keymap, keyxy, test_text)
    dist = 0
    for c in test_text
        dist = dist + key_dist(c, keymap, keyxy)
    end
    return dist
end

function total_dist(keymap, keyxy, test_text)
    letter_counts = countmap(test_text)
    for key in keymap
        if ~haskey(letter_counts, key)
            letter_counts[key] = 0
        end
    end

    counts = [letter_counts[key] for key in keymap]

    key_dists = vec(zeros(1, length(keymap)))
    for i = 1:length(key_dists)
        key_dists[i] = key_dist(i, keymap, keyxy)
    end
    return dot(counts, key_dists)
end

function total_key_dist(keymap, keyxy, test_text)
    letter_counts = countmap(test_text)
    for key in keymap
        if ~haskey(letter_counts, key)
            letter_counts[key] = 0
        end
    end

    counts = [letter_counts[key] for key in keymap]

    key_dists = vec(zeros(1, length(keymap)))
    for i = 1:length(key_dists)
        key_dists[i] = key_dist(i, keymap, keyxy)
    end

    return counts .* key_dists
end

function total_effort_iter(keymap, test_text)
    effort = 0
    for c in test_text
        if c ∈ keymap
            effort = effort + key_effort(c, keymap)
        end
    end
    return effort
end

function total_effort(keymap, keyxy, test_text)
    letter_counts = countmap(test_text)
    for key in keymap
        if ~haskey(letter_counts, key)
            letter_counts[key] = 0
        end
    end

    counts = [letter_counts[key] for key in keymap]

    key_efforts = vec(zeros(1, length(keymap)))
    for i = 1:length(key_efforts)
        key_efforts[i] = key_effort(keymap[i], keymap)
    end
    return dot(counts, key_efforts)
end

function total_key_effort(keymap, keyxy, test_text)
    letter_counts = countmap(test_text)
    for key in keymap
        if ~haskey(letter_counts, key)
            letter_counts[key] = 0
        end
    end

    counts = [letter_counts[key] for key in keymap]

    key_efforts = vec(zeros(1, length(keymap)))
    for i = 1:length(key_efforts)
        key_efforts[i] = key_effort(keymap[i], keymap)
    end

    return counts .* key_efforts
end

function total_distance_cost(keymap, test_text)
    numkeys = length(keymap)
    letter_counts = countmap(test_text)
    for key in keymap
        if ~haskey(letter_counts, key)
            letter_counts[key] = 0
        end
    end

    counts = [letter_counts[key] for key in keymap]

    key_dists = vec(zeros(1, length(keymap)))
    for i = 1:length(key_dists)
        key_dists[i] = key_dist(i, keymap, keyxy)
    end
    costs = zeros(numkeys, numkeys)
    for i in 1:numkeys
        for j in 1:numkeys
            costs[i,j] = counts[i] * key_dists[j]
        end
    end
    return costs
end

function total_effort_cost(keymap, test_text)
    numkeys = length(keymap)
    letter_counts = countmap([c for c in test_text])
    for key in keymap
        if ~haskey(letter_counts, key)
            letter_counts[key] = 0
        end
    end

    counts = [letter_counts[key] for key in keymap]

    key_efforts = vec(zeros(1, length(keymap)))
    for i = 1:length(key_efforts)
        key_efforts[i] = key_effort(keymap[i], keymap)
    end
    costs = zeros(numkeys, numkeys)
    for i in 1:numkeys
        for j in 1:numkeys
            costs[i,j] = counts[i] * key_efforts[j]
        end
    end
    return costs
end