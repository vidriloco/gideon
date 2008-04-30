require File.dirname(__FILE__) + '/../test_helper'
require 'barra_info_controller'

# Re-raise errors caught by the controller.
class BarraInfoController; def rescue_action(e) raise e end; end

class BarraInfoControllerTest < Test::Unit::TestCase
  def setup
    @controller = BarraInfoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
