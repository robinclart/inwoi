class Invoice::Document < Prawn::Document
  def self.generate(invoice, options = {})
    pdf = new(invoice, options)
    pdf.render_invoice
  end

  def initialize(invoice, options = {}, &block)
    @invoice = invoice
    super(options, &block)
  end

  attr_reader :invoice

  def render_invoice
    style_setup
    account_info
    invoice_info
    customer_address
    invoice_name
    invoice_table
    signature_space

    render_file(invoice.filename)
  end

  private

  def style_setup
    font_families.update("Open Sans" => {
      normal: "/Users/robinclart/Library/Fonts/OpenSans-Regular.ttf",
      bold: "/Users/robinclart/Library/Fonts/OpenSans-Bold.ttf",
      italic: "/Users/robinclart/Library/Fonts/OpenSans-Italic.ttf",
      bold_italic: "/Users/robinclart/Library/Fonts/OpenSans-BoldItalic.ttf"
    })
    font "Open Sans", size: 10, color: invoice.account.text_color
    default_leading 2
  end

  def account_info
    float do
      bounding_box [bounds.right - 300, bounds.top], width: 300 do
        text invoice.account.name, align: :right, style: :bold, size: 14
        text invoice.account.address, align: :right
        move_down 10
        invoice.account.banks.each do |bank|
          text bank, align: :right
        end
      end
    end
  end

  def invoice_info
    bounding_box [0, cursor], width: 240 do
      formatted_text [
        { text: "Invoice ", size: 20, color: invoice.account.signature_color },
        { text: "# #{invoice.date.year}/#{invoice.number}", color: "a8a8a8", size: 16 }
      ], style: :bold
      text invoice.date.strftime("%d %B %Y")
    end
    move_down 50
  end

  def customer_address
    text invoice.customer_name, size: 12, style: :bold
    text invoice.customer_address
    move_down 30
  end

  def invoice_name
    text invoice.project_name, size: 14, style: :bold, color: invoice.account.signature_color
    move_down 5
  end

  def invoice_table
    signature_color = invoice.account.signature_color
    table(invoice.to_a, width: bounds.right, header: true) do
      cells.inline_format = true
      cells.padding = [8, 0]
      cells.borders = [:bottom]
      cells.border_color = "e0e0e0"

      row(0).borders = [:top, :bottom]
      row(0).border_width = 1
      row(0).font_style = :bold

      row(-1).borders = [:top]
      row(-1).border_color = "878787"
      row(-1).font_color = signature_color

      columns(1..3).align = :right
      columns(1..3).width = 100
    end
    move_down 70
  end

  def signature_space
    start_new_page if cursor < 25
    indent 250 do
      dash 1
      stroke_color "878787"
      stroke_horizontal_line 0, 200
      move_down 10
      text invoice.account.approved_by
    end
  end
end

# require "prawn"
# require "date"
# require "money"

# I18n.enforce_available_locales = false
# Money.default_currency = Money::Currency.new("THB")

# class Account
#   MONEY_FORMAT = { symbol_position: :after, symbol_after_without_space: false, symbol: "THB" }
# 
#   def initialize
#     @banks = []
#   end
# 
#   attr_accessor :name
#   attr_accessor :address
#   attr_reader :banks
#   attr_accessor :approved_by
#   attr_accessor :text_color
#   attr_accessor :signature_color
#   attr_accessor :money_format
# 
#   def add_bank(bank)
#     @banks << bank
#   end
# end

# class Invoice
#   def initialize
#     @items = []
#   end
# 
#   attr_accessor :account
#   attr_accessor :number
#   attr_accessor :date
#   attr_accessor :customer_name
#   attr_accessor :customer_address
#   attr_accessor :project_name
# 
#   def filename
#     "NS#{date.year}#{number}.pdf"
#   end
# 
#   def add_item(item)
#     @items << InvoiceItem.new(*item)
#   end
# 
#   def total
#     total = @items.map(&:total).reduce(0, &:+)
#     Money.new(total * 100).format(Account::MONEY_FORMAT)
#   end
# 
#   def table_header
#     [["Description", "Quantity", "Unit Price", "Total"]]
#   end
# 
#   def table_items
#     @items.map(&:to_a)
#   end
# 
#   def table_total
#     [["", "", "Grand Total", "<b>#{total}</b>"]]
#   end
# 
#   def to_a
#     table_header + table_items + table_total
#   end
# end
# 
# class InvoiceItem
#   def initialize(name, desc, quantity, price)
#     @name = name
#     @desc = desc
#     @quantity = quantity
#     @price = price
#   end
# 
#   def total
#     @quantity * @price
#   end
# 
#   def to_a
#     ["<b>#{@name}</b>\n#{@desc}", "#{@quantity}", Money.new(@price * 100).format(Account::MONEY_FORMAT), Money.new(total * 100).format(Account::MONEY_FORMAT)]
#   end
# end
# 
# account = Account.new
# invoice = Invoice.new
# account.name = "Nongpanga Suwannasorn"
# account.approved_by = "Nongpanga Suwannasorn"
# account.address = [
#   "69/1 Charoen Sak Alley, Suthisan Road",
#   "Huai Khwang, Bangkok 10310, Thailand"
# ].join("\n")
# account.text_color = account.text_color
# account.signature_color = "121212"
# account.add_bank "Bangkok Bank (Zeer Rangsit Branch)\n028-0-09642-1"
# invoice.account = account
# invoice.number = "04"
# invoice.date = Date.parse("2014-02-25")
# invoice.customer_name = "Andre Gehrmann"
# invoice.customer_address = [
#   "Go Asia Consulting Co., Ltd",
#   "299/4 Burasiri Onnut Bang Nga",
#   "Kanchanapisek Rd., Soi 61.",
#   "Dok Mai, Prawet, 10250 Bangkok"
# ].join("\n")
# invoice.project_name = "Go Asia Manpower Website"
# invoice.add_item ["Website Design",
#   "Design the following pages for Go Asia Manpower’s website: homepage, content page, contact us page",
#   1.5, 9600
# ]
# invoice.add_item ["WordPress Integration",
#   "Turn the HTML and CSS into a custom theme using the WordPress content management system.",
#   1.5, 9600
# ]
# puts "Generating #{invoice.filename} ..."
