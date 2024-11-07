import json
import sys
from typing import Dict, List, Any
from statistics import mean, stdev

configurations = {
    1: 'default',
    2: 'chuffed',
}

def format_time(time_in_seconds: float) -> str:
    """Format time in seconds to appropriate units."""
    # if time_in_seconds < 0.001:
        # return f"{time_in_seconds * 1_000_000:.2f}~\\textmu s"
    if time_in_seconds < 1:
        # return f"{time_in_seconds * 1_000:.2f}~ms"
        return f"{time_in_seconds:.2g}~s"
    else:
        return f"{time_in_seconds:.2f}~s"

def calculate_stats(times: List[float]) -> Dict[str, float]:
    """Calculate statistics from benchmark times."""
    return {
        "mean": mean(times),
        "stddev": stdev(times) if len(times) > 1 else 0,
        "min": min(times),
        "max": max(times)
    }

def calculate_relative_change(old_value: float, new_value: float) -> str:
    """Calculate and format relative change between two values."""
    if old_value == 0:
        return "N/A"
    change = (old_value / new_value)
    # change = (new_value / old_value)
    return f"{change:.1f}x"

def calculate_relative_change_percentage(old_value: float, new_value: float) -> str:
    """Calculate and format relative change between two values."""
    if old_value == 0:
        return "N/A"
    change = ((new_value - old_value) / old_value) * 100
    return f"{'+' if change > 0 else ''}{change:.2f}\\%"

def escape_latex(text: str) -> str:
    """Escape special LaTeX characters."""
    chars = {
        '&': '\\&',
        '%': '\\%',
        '$': '\\$',
        '#': '\\#',
        '_': '\\_',
        '{': '\\{',
        '}': '\\}',
        '~': '\\textasciitilde{}',
        '^': '\\textasciicircum{}',
        '\\': '\\textbackslash{}'
    }
    return ''.join(chars.get(c, c) for c in text)

def compare_benchmark_positions(json_files: List[str]) -> str:
    """Compare commands at the same position across different benchmark files."""
    # Load all benchmark results
    benchmarks = []
    for file_path in json_files:
        with open(file_path) as f:
            benchmarks.append(json.load(f))
    # Get the number of commands in the first benchmark
    num_commands = len(benchmarks[0]["results"])
    latex_output = [
        "\\documentclass{article}",
        "\\usepackage{booktabs}",
        "\\usepackage{tabularx}",
        "\\usepackage[table]{xcolor}",
        "\\begin{document}"
    ]
    # Compare each command position
    for pos in range(num_commands):
        commands = [bench["results"][pos] for bench in benchmarks]
        # Get all command texts
        latex_output.extend([
            f"\\subsection*{{Command Position {pos + 1}}}",
            "Command variations across runs:",
            "\\begin{itemize}"
        ])
        for i, cmd in enumerate(commands):
            latex_output.append(f"\\item Run {i+1}: \\texttt{{{escape_latex(cmd['command'])}}}")
        latex_output.extend([
            "\\end{itemize}",
            "\\begin{table}[h]",
            "\\centering",
            "\\begin{tabular}{llrrrrrr}",
            "Aliens & Configuration & Mean & Std Dev & Min & Max & Times faster & Percentage \\\\",
            "\\hline"
        ])
        # Calculate stats for each run
        first_mean = None
        for i, cmd in enumerate(commands):
            stats = calculate_stats(cmd["times"])
            if first_mean is None:
                first_mean = stats["mean"]
                change = "1x"
                change_perc = "baseline"
            else:
                change = calculate_relative_change(first_mean, stats["mean"])
                change_perc = calculate_relative_change_percentage(first_mean, stats["mean"])
            row = "{} & {} & {} & {} & {} & {} & {} & {} \\\\".format(
                f'aliens{pos + 1}',
                configurations[i + 1],
                format_time(stats["mean"]),
                format_time(stats["stddev"]),
                format_time(stats["min"]),
                format_time(stats["max"]),
                change,
                change_perc,
            )
            latex_output.append(row)
        latex_output.extend([
            "\\end{tabular}",
            "\\end{table}",
            ""
        ])
    latex_output.append("\\end{document}")
    return "\n".join(latex_output)

def compare_benchmark_positions2(json_files: List[str]) -> str:
    """Compare commands at the same position across different benchmark files."""
    # Load all benchmark results
    benchmarks = []
    for file_path in json_files:
        with open(file_path) as f:
            benchmarks.append(json.load(f))
    # Get the number of commands in the first benchmark
    num_commands = len(benchmarks[0]["results"])
    latex_output = [
        "\\documentclass{article}",
        "\\usepackage{booktabs}",
        "\\usepackage{tabularx}",
        "\\usepackage[table]{xcolor}",
        "\\begin{document}"
    ]

    latex_output.extend([
        "\\begin{table}",
        "\\begin{tabular}{|llrrrrrr|}",
        "\\hline",
        "Aliens & Configuration & Mean & Std Dev & Min & Max & Times faster & Percentage \\\\",
        "\\hline"
    ])
    # Compare each command position
    for pos in range(num_commands):
        commands = [bench["results"][pos] for bench in benchmarks]

        # Calculate stats for each run
        first_mean = None
        for i, cmd in enumerate(commands):
            stats = calculate_stats(cmd["times"])
            if first_mean is None:
                first_mean = stats["mean"]
                change = "1.0x"
                change_perc = "baseline"
            else:
                change = calculate_relative_change(first_mean, stats["mean"])
                change_perc = calculate_relative_change_percentage(first_mean, stats["mean"])
            row = "{} & {} & {} & {} & {} & {} & {} & {} \\\\".format(
                f'aliens{pos + 1}',
                configurations[i + 1],
                format_time(stats["mean"]),
                format_time(stats["stddev"]),
                format_time(stats["min"]),
                format_time(stats["max"]),
                change,
                change_perc,
            )
            latex_output.append(row)
        latex_output.extend([
            "\\hline"
        ])
    latex_output.extend([
        "\\end{tabular}",
        "\\end{table}",
        ""
    ])
    latex_output.append("\\end{document}")
    return "\n".join(latex_output)

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py benchmark1.json benchmark2.json benchmark3.json")
        sys.exit(1)
    # print(compare_benchmark_positions(sys.argv[1:]))
    print(compare_benchmark_positions2(sys.argv[1:]))

if __name__ == "__main__":
    main()
