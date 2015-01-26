d_rgb <- horizons(f)[, c("d_r", "d_g", "d_b")]
d_munsell <- rgb2munsell(d_rgb)
m_rgb <- h[, c("m_r", "m_g", "m_b")]
m_munsell <- rgb2munsell(m_rgb)

h$d_hue <- as.character(d_munsell$hue)
h$d_value <- as.integer(d_munsell$value)
h$d_chroma <- as.integer(d_munsell$chroma)
h$m_hue <- as.character(m_munsell$hue)
h$m_value <- as.integer(m_munsell$value)
h$m_chroma <- as.integer(d_munsell$chroma)
