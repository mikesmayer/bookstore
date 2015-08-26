module StateMachineMethods

  extend ActiveSupport::Concern

  included do 
    aasm column: :status do
      state :in_progress, :initial => true
      state :in_process
      state :shipping
      state :done
      state :canceled
      state :done

      event :set_in_process do
        before do
          self.completed_date = DateTime.now
        end
        transitions :from => :in_progress, :to => :in_process
      end

      event :set_in_shipping do
        transitions :from => :in_process, :to => :shipping
      end

      event :set_in_done do
        transitions :from => :shipping, :to => :done
      end

      event :cancel do
        transitions :from => :in_process, :to => :canceled
      end
    end
  end

  def next_state
    states = self.aasm.states(:permitted => true).map(&:name)
    states.first
  end

  def order_steps
    {address:       true, 
     delivery:      self.shipping_address.nil? ? false : self.shipping_address.valid? &&
                    self.billing_address.nil?  ? false : self.billing_address.valid?,
     payment:       self.delivery_id.nil?      ? false : true,
     confirm:       self.credit_card.nil?      ? false : self.credit_card.valid?}
  end

  def available_steps
    steps = [ ]
    order_steps.each{|step, passed| steps << step if passed == true}
    steps
  end
end