#!/usr/bin/env julia

"""
Dependency Graph Extractor for control-toolbox ecosystem

This script extracts the dependency graph with versions for CT* packages.
It can use different strategies.
"""

using Pkg
using Dates

function extract_graph_from_pkg()
    """Strategy 1: Use Pkg.dependencies() API"""
    println("=== Strategy 1: Pkg.dependencies() ===\n")

    deps = Pkg.dependencies()
    ct_pkgs = filter(p -> startswith(p.second.name, "CT") || p.second.name == "OptimalControl", deps)

    # Build graph
    graph = Dict()
    for (uuid, pkg) in ct_pkgs
        pkg_deps = []
        if !isnothing(pkg.dependencies)
            for (dep_name, dep_uuid) in pkg.dependencies
                if haskey(deps, dep_uuid) && (startswith(deps[dep_uuid].name, "CT") || deps[dep_uuid].name == "OptimalControl")
                    push!(pkg_deps, (deps[dep_uuid].name, deps[dep_uuid].version))
                end
            end
        end
        graph[pkg.name] = (pkg.version, pkg_deps)
    end

    return graph
end

function print_graph(graph)
    """Print graph in readable format"""
    # Start with OptimalControl
    if haskey(graph, "OptimalControl")
        version, deps = graph["OptimalControl"]
        println("OptimalControl v$version")
        for (dep_name, dep_version) in deps
            println("  ├── $dep_name v$dep_version")
            if haskey(graph, dep_name)
                _, subdeps = graph[dep_name]
                for (subdep_name, subdep_version) in subdeps
                    println("  │   └── $subdep_name v$subdep_version")
                end
            end
        end
    end

    println("\n=== Full Graph ===\n")
    for (pkg_name, (version, deps)) in sort(collect(graph))
        println("$pkg_name v$version")
        for (dep_name, dep_version) in deps
            println("  → $dep_name v$dep_version")
        end
        println()
    end
end

function export_to_markdown(graph, filename="dependency-graph.md")
    """Export graph to markdown format"""
    open(filename, "w") do io
        write(io, "# control-toolbox Dependency Graph\n\n")
        write(io, "**Generated**: $(now())\n\n")
        write(io, "## Tree View\n\n")
        write(io, "```\n")

        if haskey(graph, "OptimalControl")
            version, deps = graph["OptimalControl"]
            write(io, "OptimalControl v$version\n")
            for (i, (dep_name, dep_version)) in enumerate(deps)
                is_last = i == length(deps)
                prefix = is_last ? "└──" : "├──"
                write(io, "  $prefix $dep_name v$dep_version")

                if haskey(graph, dep_name)
                    _, subdeps = graph[dep_name]
                    if !isempty(subdeps)
                        write(io, " →")
                        for (j, (subdep_name, subdep_version)) in enumerate(subdeps)
                            if j == 1
                                write(io, " $subdep_name v$subdep_version")
                            else
                                write(io, ", $subdep_name v$subdep_version")
                            end
                        end
                    end
                end
                write(io, "\n")
            end
        end

        write(io, "```\n\n")
        write(io, "## Package Details\n\n")

        for (pkg_name, (version, deps)) in sort(collect(graph))
            write(io, "### $pkg_name v$version\n\n")
            if isempty(deps)
                write(io, "No CT dependencies\n\n")
            else
                write(io, "**Dependencies**:\n")
                for (dep_name, dep_version) in deps
                    write(io, "- $dep_name v$dep_version\n")
                end
                write(io, "\n")
            end
        end
    end
    println("Graph exported to $filename")
end

# Main execution
if abspath(PROGRAM_FILE) == @__FILE__
    println("Extracting dependency graph...\n")
    graph = extract_graph_from_pkg()
    print_graph(graph)
    export_to_markdown(graph)
end
