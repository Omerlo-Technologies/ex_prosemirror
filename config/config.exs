use Mix.Config

config :ex_prosemirror,
  debug: false,
  default: [
    blocks: [:p, :h1, :h2]
  ]

if Mix.env() == :test do
  config :ex_prosemirror,
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
