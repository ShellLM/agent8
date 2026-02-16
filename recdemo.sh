recdemo() {
        local video_size="${1:-$(xrandr 2>/dev/null | grep '*' | awk '{print $1}' | head -1)}"
        local duration="${2:-}"
        local output_file="${3:-}"
        local display="${DISPLAY:-:0.0}"

        # Fallback resolution if xrandr fails
        if [[ -z "$video_size" ]]; then
                video_size="1920x1080"
        fi

        # Generate default filename patterned after recai()
        if [[ -z "$output_file" ]]; then
                local dir_name=$(basename "$(pwd)" | cut -c1-15)
                local datetime=$(date +%Y%m%d%H%M)
                output_file="$HOME/ai/Recordings/demo_${dir_name}_${datetime}.mp4"
        fi

        if ! command -v ffmpeg &> /dev/null; then
                echo "Error: ffmpeg is not installed" >&2
                return 1
        fi

        mkdir -p "$(dirname "$output_file")"

        local ffmpeg_args=(-f x11grab -video_size "$video_size" -i "$display" -pix_fmt yuv420p -movflags +faststart)

        if [[ -n "$duration" ]]; then
                ffmpeg_args+=(-t "$duration")
        fi

        echo "Recording screen..."
        echo "Resolution: $video_size"
        echo "Display: $display"
        if [[ -n "$duration" ]]; then
                echo "Duration: $duration"
        else
                echo "Duration: unlimited (press Ctrl+C to stop)"
        fi
        echo "Output: $output_file"
        echo "Starting in 3 seconds..."
        sleep 3

        if ffmpeg -hide_banner "${ffmpeg_args[@]}" "$output_file"; then
                echo "Saved to: $output_file"
        else
                echo "Recording interrupted" >&2
                [[ -f "$output_file" && ! -s "$output_file" ]] && rm "$output_file"
                return 1
        fi
}

