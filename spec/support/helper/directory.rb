module DirectoryHelper
  def root_path
    Pathname(root_dir)
  end

  def fixtures_path
    root_path.join('spec', 'fixtures')
  end

  private

  def root_dir
    File.expand_path('../../../', File.dirname(__FILE__))
  end
end
