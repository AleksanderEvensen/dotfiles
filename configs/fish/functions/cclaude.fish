function cclaude --description "Run Claude Code through CLI-Proxy-API using gpt-5.6 models"
    set -lx ANTHROPIC_BASE_URL http://127.0.0.1:8317
    set -lx ANTHROPIC_AUTH_TOKEN sk-dummy

    # Claude Code 2.x model mappings.
    set -lx ANTHROPIC_DEFAULT_OPUS_MODEL gpt-5.6-sol
    set -lx ANTHROPIC_DEFAULT_SONNET_MODEL gpt-5.6-terra
    set -lx ANTHROPIC_DEFAULT_HAIKU_MODEL gpt-5.6-luna

    # Claude Code 1.x model mappings.
    set -lx ANTHROPIC_MODEL gpt-5.6-sol
    set -lx ANTHROPIC_SMALL_FAST_MODEL gpt-5.6-luna

    command claude $argv
end
