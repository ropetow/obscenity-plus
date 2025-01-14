require 'rack/mock'
require 'obscenity/rack'

RSpec.describe Rack::Obscenity do
  let(:app) do
    lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['hello']] }
  end

  let(:env) { Rack::MockRequest.env_for('/') }

  def middleware(options = {})
    described_class.new(app, options)
  end

  def get(params = {})
    { 'QUERY_STRING' => Rack::Utils.build_query(params) }
  end

  def post(params = {})
    { 'rack.input' => StringIO.new(Rack::Utils.build_query(params)) }
  end

  def parse_query(query)
    Rack::Utils.parse_query(query, '&')
  end

  def get_response_params(env)
    parse_query(env['QUERY_STRING'])
  end

  def post_response_params(env)
    parse_query(env['rack.input'].read)
  end

  def call_middleware(middleware, options)
    middleware.call(Rack::MockRequest.env_for('/', options))
  end

  it "does not evaluate profanity by default" do
    app = middleware
    status, headers, body = call_middleware(app, {})
    expect(status).to eq(200)
    expect(headers).to eq('Content-Type' => 'text/plain')
    expect(body).to eq(['hello'])
  end

  context "rejecting requests" do
    it "does not reject non-profane parameters" do
      app = middleware(reject: true)
      status, headers, body = call_middleware(app, get(foo: 'bar'))
      expect(status).to eq(200)
      expect(headers).to eq('Content-Type' => 'text/plain')
      expect(body).to eq(['hello'])
    end

    it "rejects requests with GET parameters containing profanity" do
      app = middleware(reject: true)
      status, headers, body = call_middleware(app, get(foo: 'bar', baz: 'shit'))
      expect(status).to eq(422)
      expect(body).to eq([''])
    end

    it "rejects requests with POST parameters containing profanity" do
      app = middleware(reject: true)
      status, headers, body = call_middleware(app, post(foo: 'bar', baz: 'ass'))
      expect(status).to eq(422)
      expect(body).to eq([''])
    end

    it "rejects requests with specific parameter values containing profanity" do
      app = middleware(reject: { params: [:foo] })
      status, headers, body = call_middleware(app, get(foo: 'ass', baz: 'clean'))
      expect(status).to eq(422)
      expect(body).to eq([''])
    end

    it "does not reject requests if other parameter values contain profanity" do
      app = middleware(reject: { params: [:foo] })
      status, headers, body = call_middleware(app, get(foo: 'clean', baz: 'shit'))
      expect(status).to eq(200)
      expect(headers).to eq('Content-Type' => 'text/plain')
      expect(body).to eq(['hello'])
    end
  end

  context "sanitizing requests" do
    it "does not sanitize non-profane parameters" do
      app = middleware(sanitize: true)
      status, headers, body = call_middleware(app, get(foo: 'bar'))
      expect(status).to eq(200)
      expect(headers).to eq('Content-Type' => 'text/plain')
      expect(body).to eq(['hello'])

      request_params = get_response_params(env)
      expect(request_params['foo']).to eq('bar')
    end

    it "sanitizes GET parameters containing profanity" do
      app = middleware(sanitize: tru
