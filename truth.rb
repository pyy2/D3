require 'sinatra'
require 'sinatra/reloader'

# If a GET request comes in at /, do the following
get '/' do
  erb :index
end

not_found do
  status 404
  erb :error_404
end

def check_args?(t, f, size)
  if (t.length != 1 || f.length != 1 || (t.eql? f) || size.to_i < 2 || !Integer(size)) 
    false
  else
    true 
  end
end

# If a POST request comes in at /, do the following
post '/' do
  # Store the parameters to local variables
  t = params['t']
  f = params['f']
  size = params['size']

  # Initialize parameters if not initialized
  t = 'T' if t.length == 0
  f = 'F' if f.length == 0
  size = 3 if size.length == 0

  # If valid args, make table
  # else report error 400
  if check_args? t, f, size
    table = create_table t, f, size.to_i  
    erb :truth_table, :locals => {bit_number: table[0], bit_row: table[1], and_row: table[2], or_row: table[3], xor_row: table[4]}
  else   
    status 400
    erb :error_400
  end
end

def create_table(t, f, size)
  and_row = []
  or_row = []
  xor_row = []

  column = ([*0..size-1]*' ').reverse!
  bit_row = [t, f].repeated_permutation(size).to_a

  # For each row, check for AND, OR, XOR operations
  bit_row.each do |check|
    if check.include? f
      and_row.push f
    else
      and_row.push t
    end
    if check.include? t
      or_row.push t
    else
      or_row.push f
    end
    if check.count(t)%2 == 1
      xor_row.push t
    else
      xor_row.push f
    end
  end
  return column, bit_row, and_row, or_row, xor_row
end