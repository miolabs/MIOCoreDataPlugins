import PackagePlugin
import Foundation

@main
struct MIOCoreDataBuildModelPlugin: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
//        guard let sourceFiles = target.sourceModule?.sourceFiles else { return [] }
        
        // Find the code generator tool to run (replace this with the actual one).
//        let generatorTool = try context.tool( named: "miotool" )
        
        // Construct a build command for each source file with a particular suffix.
//        return sourceFiles.map(\.path).compactMap {
//            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path)
//        }
        return [ ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MIOCoreDataBuildModelPlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // Find the code generator tool to run (replace this with the actual one).
        let generatorTool = try context.tool(named: "miotool")
                
        // Construct a build command for each source file with a particular suffix.
        return target.inputFiles.map(\.path).compactMap {
            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path, configPath: context.xcodeProject.directory )
        }
    }
}

#endif

extension MIOCoreDataBuildModelPlugin {
    /// Shared function that returns a configured build command if the input files is one that should be processed.
    func createBuildCommand(for inputPath: Path, in outputDirectoryPath: Path, with generatorToolPath: Path, configPath: Path? ) -> Command? {
        // Skip any file that doesn't have the extension we're looking for (replace this with the actual one).
        guard inputPath.extension == "xcdatamodeld" else { return .none }
                
//        let path = configPath.appending( subpath: "mio_plugins.json" )
//        print("Search for plugin configuration file at \(path)" )
//        let data = try? Data(contentsOf: path )
        var arguments = ["model", "generate", "\(inputPath)", "-o", "\(outputDirectoryPath)", "--swift"]
        
        //#if os(iOS)
        arguments.append( "--objc-support" )
        //#endif
        
        // Return a command that will run during the build to generate the output file.
        return .prebuildCommand(
            displayName: "Generating model classes",
            executable: generatorToolPath,
            arguments: arguments,
            outputFilesDirectory: outputDirectoryPath
        )
    }
}

