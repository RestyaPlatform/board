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
        self.model.url = api_url + 'boards/' + self.model.id + '/labels/' + this.label_id + '.json';
        self.model.attributes.lists.forEach(function(list, index) {
            if (!_.isEmpty(list)) {
                _.each(list.cards, function(card, index1) {
                    _.each(card.cards_labels, function(labels, key) {
                        if (!_.isEmpty(labels)) {
                            if (!_.isUndefined(labels.label_id) && labels.label_id === self.label_id) {
                                self.model.attributes.lists[index].cards[index1].cards_labels.splice(key, 1);
                            }
                        }
                    });
                });
            }
        });
        self.model.destroy({
            success: function(model, response) {
                self.flash('success', i18next.t('Labels deleted successfully.'));
                $('.js-show-labels').trigger('click');
            }
        });
        this.renderCardsCollection();
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
    },
});
