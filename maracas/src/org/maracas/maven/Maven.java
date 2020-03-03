package org.maracas.maven;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.eclipse.aether.artifact.Artifact;
import org.eclipse.aether.artifact.DefaultArtifact;
import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.values.ValueFactoryFactory;

import com.google.common.io.Files;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import nl.cwi.swat.aethereal.AetherDownloader;

public class Maven {
	private IValueFactory vf;
	private AetherDownloader downloader = new AetherDownloader(15);

	public Maven(IValueFactory vf) {
		this.vf = vf;
	}

	public ISourceLocation downloadJar(IString group, IString artifact, IString version, ISourceLocation dest, IEvaluatorContext ctx) throws IOException {
		Artifact resolved = downloader.downloadArtifact(new DefaultArtifact(group.getValue(), artifact.getValue(), "jar", version.getValue()));
		File destJar = Paths.get(dest.getURI().getPath()).resolve(resolved.getFile().getName()).toFile();
		Files.copy(resolved.getFile(), destJar);
		return vf.sourceLocation(destJar.getAbsolutePath());
	}
	
	public ISourceLocation downloadSources(IString group, IString artifact, IString version, ISourceLocation dest, IEvaluatorContext ctx) throws IOException {
		Artifact resolved = downloader.downloadArtifact(new DefaultArtifact(group.getValue(), artifact.getValue(), "sources", "jar", version.getValue()));
		File destJar = Paths.get(dest.getURI().getPath()).resolve(resolved.getFile().getName()).toFile();
		Files.copy(resolved.getFile(), destJar);
		return vf.sourceLocation(destJar.getAbsolutePath());
	}
	
	public static void main(String[] args) {
		IValueFactory vf = ValueFactoryFactory.getValueFactory();
		new Maven(vf).extractJar(vf.sourceLocation("/home/dig/guava-report/guava-18.0.jar"), vf.sourceLocation("/home/dig/guava-report/18.0-extracted"), null);
	}

	public ISourceLocation extractJar(ISourceLocation jar, ISourceLocation dest, IEvaluatorContext ctx) {
		String fileZip = jar.getURI().getPath();
		Path destPath = Paths.get(dest.getURI().getPath());
		File destDir = destPath.toFile();
		destDir.mkdirs();
		byte[] buffer = new byte[1024];
		try (ZipInputStream zis = new ZipInputStream(new FileInputStream(fileZip))) {
			ZipEntry zipEntry = zis.getNextEntry();
			while (zipEntry != null) {
				File newFile = newFile(destDir, zipEntry);
				System.out.println("newFile="+newFile);
				newFile.getParentFile().mkdirs();
				if (!zipEntry.isDirectory()) {
					FileOutputStream fos = new FileOutputStream(newFile);
					int len;
					while ((len = zis.read(buffer)) > 0) {
						fos.write(buffer, 0, len);
					}
					fos.close();
				}
				zipEntry = zis.getNextEntry();
			}
			zis.closeEntry();
			zis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return vf.sourceLocation(destDir.getAbsolutePath());
	}

	public File newFile(File destinationDir, ZipEntry zipEntry) throws IOException {
		File destFile = new File(destinationDir, zipEntry.getName());

		String destDirPath = destinationDir.getCanonicalPath();
		String destFilePath = destFile.getCanonicalPath();

		if (!destFilePath.startsWith(destDirPath + File.separator)) {
			throw new IOException("Entry is outside of the target dir: " + zipEntry.getName());
		}

		return destFile;
	}
}