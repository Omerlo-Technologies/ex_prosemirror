import Config

config :ex_prosemirror,
  debug: false,
  env: config_env()

if config_env() == :test do
  config :ex_prosemirror,
    marks_modules: [
      em: ExProsemirror.Mark.Em,
      strong: ExProsemirror.Mark.Strong,
      underline: ExProsemirror.Mark.Underline
    ],
    blocks_modules: [
      paragraph: ExProsemirror.Block.Paragraph,
      heading: ExProsemirror.Block.Heading,
      image: ExProsemirror.Block.Image,
      text: ExProsemirror.Block.Text
    ],
    types: [
      marks_only: [
        blocks: [],
        marks: [:em]
      ],
      blocks_only: [
        blocks: [:paragraph],
        marks: []
      ],
      title: [
        inline: true,
        marks: [:strong],
        blocks: [{:heading, [1, 2]}, :paragraph]
      ],
      sublead: [
        marks: [:em],
        blocks: [{:heading, [2, 3]}]
      ],
      empty: [
        marks: [],
        blocks: []
      ]
    ]
end
