require "sinatra"
require 'digest'
require "omniauth-github"
require "octokit"
require "securerandom"
require "awesome_print" if ENV["RACK_ENV"] == "development"

GITHUB_KEY = ENV["GITHUB_KEY"]
GITHUB_SECRET = ENV["GITHUB_SECRET"]
SESSION_SECRET = ENV["SESSION_SECRET"] || SecureRandom.hex
TILLAGE_REPO_URL = ENV["TILLAGE_REPO_URL"] || "https://github.com/platanus/tillage"
TILLAGE_INSTALL_PATH = ENV["TILLAGE_INSTALL_PATH"] || "/opt/tillage"
TILLAGE_ISSUES_URL = ENV["TILLAGE_ISSUES_URL"] || "#{TILLAGE_REPO_URL}/issues/new"

set :sessions, secret: SESSION_SECRET

use OmniAuth::Builder do
  provider :github, GITHUB_KEY, GITHUB_SECRET, scope: "user:email,repo"
end

def get_install_script(auth = nil)
  content = IO.read(File.expand_path("#{File.dirname(__FILE__)}/../script/install"))

  if auth
    content.gsub!(/(STRAP_GIT_NAME=)$/, "\\1\"#{auth['info']['name']}\"")
    content.gsub!(/(STRAP_GIT_EMAIL=)$/, "\\1\"#{auth['info']['email']}\"")
    content.gsub!(/(STRAP_GITHUB_USER=)$/, "\\1\"#{auth['info']['nickname']}\"")
    content.gsub!(/(STRAP_GITHUB_TOKEN=)$/, "\\1\"#{auth['credentials']['token']}\"")
  end

  content.gsub!(/(TILLAGE_REPO_URL=)$/, "\\1\"#{TILLAGE_REPO_URL}\"")
  content.gsub!(/(TILLAGE_INSTALL_PATH=)$/, "\\1\"#{TILLAGE_INSTALL_PATH}\"")
  content.gsub!(/(TILLAGE_ISSUES_URL=)$/, "\\1\"#{TILLAGE_ISSUES_URL}\"")
end

get "/auth/github/callback" do
  session[:auth] = request.env["omniauth.auth"]
  return_to = session.delete :return_to
  return_to = "/" if !return_to || return_to.empty?
  redirect to return_to
end

get "/" do
  auth = session[:auth]

  if !auth && GITHUB_KEY && GITHUB_SECRET
    query = request.query_string
    query = "?#{query}" if query && !query.empty?
    session[:return_to] = "#{request.path}#{query}"
    redirect to "/auth/github"
  end

  if request.scheme == "http" && ENV["RACK_ENV"] != "development"
    redirect to "https://#{request.host}#{request.fullpath}"
  end

  content = get_install_script auth

  script_hash = Digest::SHA256.hexdigest("#{content}-#{Time.now.to_i}")[8..16]
  script_path = File.join(Dir.tmpdir, script_hash)

  open(script_path, 'w') do |f|
    f.puts content
  end

  @install_script_url = "curl -s #{request.base_url}/install/#{script_hash} > \
    /tmp/install-tillage.sh; bash /tmp/install-tillage.sh"

  erb :root
end

get "/install" do
  content = get_install_script

  content_type = params["text"] ? "text/plain" : "application/octet-stream"

  erb content, content_type: content_type
end

get "/install/:hash" do
  script_path = File.join(Dir.tmpdir, params['hash'])

  halt 404 unless Time.now.utc - File.mtime(script_path).utc < 60

  content = IO.read(script_path)

  content_type = params["text"] ? "text/plain" : "application/octet-stream"

  erb content, content_type: content_type
end
