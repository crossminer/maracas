/*
 * Copyright 2015 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.uberfire.java.nio.fs.jgit.daemon.ssh;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.sshd.common.Session;
import org.apache.sshd.common.channel.ChannelOutputStream;
import org.apache.sshd.server.Command;
import org.apache.sshd.server.Environment;
import org.apache.sshd.server.ExitCallback;
import org.apache.sshd.server.SessionAware;
import org.apache.sshd.server.session.ServerSession;
import org.eclipse.jgit.errors.RepositoryNotFoundException;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.transport.ServiceMayNotContinueException;
import org.eclipse.jgit.transport.resolver.ServiceNotAuthorizedException;
import org.eclipse.jgit.transport.resolver.ServiceNotEnabledException;
import org.uberfire.commons.async.DescriptiveRunnable;
import org.uberfire.commons.async.DescriptiveThreadFactory;
import org.uberfire.java.nio.fs.jgit.JGitFileSystem;
import org.uberfire.java.nio.fs.jgit.JGitFileSystemProvider;
import org.uberfire.java.nio.security.FileSystemAuthorizer;
import org.uberfire.java.nio.security.FileSystemUser;

public abstract class BaseGitCommand implements Command,
                                                SessionAware,
                                                Runnable {

    public final static Session.AttributeKey<FileSystemUser> SUBJECT_KEY = new Session.AttributeKey<FileSystemUser>();

    protected final String command;
    protected final String repositoryName;
    protected final FileSystemAuthorizer fileSystemAuthorizer;
    protected final JGitFileSystemProvider.RepositoryResolverImpl<BaseGitCommand> repositoryResolver;
    private final ExecutorService executorService;

    private InputStream in;
    private OutputStream out;
    private OutputStream err;
    private ExitCallback callback;
    private FileSystemUser user;

    public BaseGitCommand(final String command,
                          final FileSystemAuthorizer fileSystemAuthorizer,
                          final JGitFileSystemProvider.RepositoryResolverImpl<BaseGitCommand> repositoryResolver,
                          final ExecutorService executorService) {
        this.command = command;
        this.fileSystemAuthorizer = fileSystemAuthorizer;
        this.repositoryName = buildRepositoryName(command);
        this.repositoryResolver = repositoryResolver;
        this.executorService = executorService;
    }

    private String buildRepositoryName(String command) {
        int start = getCommandName().length() + 2;
        final String temp = command.substring(start);
        return temp.substring(0,
                              temp.indexOf("'"));
    }

    protected abstract String getCommandName();

    @Override
    public void setInputStream(InputStream in) {
        this.in = in;
    }

    @Override
    public void setOutputStream(OutputStream out) {
        this.out = out;
        if (out instanceof ChannelOutputStream) {
            ((ChannelOutputStream) out).setNoDelay(true);
        }
    }

    @Override
    public void setErrorStream(OutputStream err) {
        this.err = err;
        if (err instanceof ChannelOutputStream) {
            ((ChannelOutputStream) err).setNoDelay(true);
        }
    }

    @Override
    public void setExitCallback(ExitCallback callback) {
        this.callback = callback;
    }

    @Override
    public void start(final Environment env) throws IOException {
        this.executorService.execute(new DescriptiveRunnable() {
            @Override
            public String getDescription() {
                return "Git Command [" + getClass().getName() + "]";
            }

            @Override
            public void run() {
                BaseGitCommand.this.run();
            }
        });
    }

    @Override
    public void run() {
        try {
            final Repository repository = openRepository(repositoryName);
            if (repository != null) {
                final JGitFileSystem fileSystem = repositoryResolver.resolveFileSystem(repository);

                if (fileSystemAuthorizer.authorize(fileSystem,
                                                   user)) {
                    execute(user,
                            repository,
                            in,
                            out,
                            err,
                            fileSystem);
                } else {
                    err.write("Invalid credentials.".getBytes());
                }
            } else {
                err.write("Can't resolve repository name.".getBytes());
            }
        } catch (final Throwable ignored) {
        }
        if (callback != null) {
            callback.onExit(0);
        }
    }

    private Repository openRepository(String name)
            throws ServiceMayNotContinueException {
        // Assume any attempt to use \ was by a Windows client
        // and correct to the more typical / used in Git URIs.
        //
        name = name.replace('\\',
                            '/');

        // git://thishost/path should always be name="/path" here
        //
        if (!name.startsWith("/")) {
            return null;
        }

        try {
            return repositoryResolver.open(this,
                                           name.substring(1));
        } catch (RepositoryNotFoundException e) {
            // null signals it "wasn't found", which is all that is suitable
            // for the remote client to know.
            return null;
        } catch (ServiceNotAuthorizedException e) {
            // null signals it "wasn't found", which is all that is suitable
            // for the remote client to know.
            return null;
        } catch (ServiceNotEnabledException e) {
            // null signals it "wasn't found", which is all that is suitable
            // for the remote client to know.
            return null;
        }
    }

    protected abstract void execute(final FileSystemUser user,
                                    final Repository repository,
                                    final InputStream in,
                                    final OutputStream out,
                                    final OutputStream err,
                                    final JGitFileSystem fileSystem);

    @Override
    public void destroy() {
    }

    public FileSystemUser getUser() {
        return user;
    }

    @Override
    public void setSession(final ServerSession session) {
        this.user = session.getAttribute(BaseGitCommand.SUBJECT_KEY);
    }
}
