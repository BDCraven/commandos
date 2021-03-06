require 'printer'

describe Printer do
  subject(:printer) { described_class.new(output_file, waited_file, 5) }
  let(:output_file) { 'output_test.txt' }
  let(:waited_file) { 'waited_tips_test.txt' }

  let!(:tip) { 'You can use mv to rename a file.' }
  let!(:waited_tips) do
    ['The command cat -n will print line numbers next to each line in a file.',
     'You can switch between 2 directories using cd -',
     'You can view more information about your files using ls -l',
     'You can open your current directory in finder with open .',
     'Use rm -i to be prompted for confirmation before attempting to remove each file']
  end

  describe 'output' do
    it 'prints the tip when output type is print' do
      expect { printer.output(tip, 'print') }.to output("\e[32m#{tip}\e[0m\n").to_stdout
    end

    it 'writes the tip to the file when output type is file' do
      printer.output(tip, 'file')
      expect(output_file).to have_file_content tip + "\n"
    end

    # it 'speaks the tip when output type is speech' do
    #   expect { printer.output(tip, 'speech') }.not_to raise_error # needs changing
    # end

    it 'prints the tip when output type is not print/file/speech' do
      expect { printer.output(tip, 'gobbledygook') }.to output("\e[32m#{tip}\e[0m\n").to_stdout
    end
  end

  describe '#add_to_waited_tips' do
    context 'there are less than N tips in waiting' do
      it 'adds the tip to the waiting tips file' do
        write_to_file(waited_file, waited_tips[0..3]) # set up waiting file before test
        printer.add_to_waited_tips(tip)
        expect(waited_file).to have_file_content waited_tips[0..3].join("\n") + "\n" + tip
        write_to_file(waited_file, waited_tips) # restore waititng file
      end
    end

    context 'there are N tips in waiting' do
      it 'adds the tip to the waiting tips file and removes the first tip' do
        printer.add_to_waited_tips(tip)
        expect(waited_file).to have_file_content waited_tips[1..4].join("\n") + "\n" + tip
        write_to_file(waited_file, waited_tips) # restore waiting file
      end
    end
  end
end

def write_to_file(filename, records)
  filename = File.join(File.dirname(__FILE__), '../output/', filename)
  File.open(filename, 'w') do |file|
    records.each do |line|
      file.puts line
    end
  end
end
