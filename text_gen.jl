using StatsBase
using DelimitedFiles

function generate_text(words, wv, n)
    word = StatsBase.sample(words, Weights(wv), n)
    sample_text = ""
    for word in word
        sample_text = string(sample_text, " ", word)
    end
    return sample_text[2:end]
end