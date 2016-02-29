App.LabelDeleteConfirmView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.label_id = options.label_id;
        this.render();
    },
    template: JST['templates/label_delete_confirm'],
    tagName: 'div',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-label-confirm-delete': 'labelConfirmDelete',
        'click .js-close-popup': 'closePopup',
    },
    labelConfirmDelete: function(e) {
        var self = this;
        self.model.url = api_url + 'boards/' + self.model.id + '/labels/' + self.label_id + '.json';
        self.model.destroy({
            success: function(model, response) {
                self.flash('success', i18next.t('Labels deleted successfully.'));
                $('.js-show-labels').trigger('click');
                var filter_labels = self.model.labels.filter(function(model) {
                    return parseInt(model.get('label_id')) === parseInt(self.label_id);
                });
                self.model.labels.remove(filter_labels);
            }
        });
        return false;
    },
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown:first, div.dropdown:first').removeClass('open');
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            label: this.model
        }));
        this.showTooltip();
        return this;
    }
});
