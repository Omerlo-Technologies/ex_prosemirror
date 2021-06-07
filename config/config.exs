use Mix.Config

config :ex_prosemirror,
  debug: false,
  default_blocks: [:p, :h1, :h2, :h3, :h4, :h5, :h6, :image],
  default_marks: [:em, :strong, :underline]

if Mix.env() == :test do
  config :ex_prosemirror,
    default_blocks: [:p, :h1, :h2],
    default_marks: [:em, :strong],
    default: [
      blocks: [:p, :h1, :h2]
    ],
    types: [
      title: [
        marks: [:strong],
        blocks: [:h1, :h2]
      ],
      lead: [],
      sublead: [
        marks: [:em],
        blocks: [:h2, :h3]
      ],
      empty: [
        marks: [],
        blocks: []
      ]
    ]
end
