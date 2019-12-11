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
                self.flash('success', i18next.t('Label deleted successfully.'));
                $('.js-show-labels').trigger('click');
                var deleteLabelcards = self.model.cards.filter(function(card) {
                    return card.get('is_archived') !== 1 && !_.isUndefined(card.labels) && card.labels.length > 0 && !_.isEmpty(card.labels.findWhere({
                        label_id: parseInt(self.label_id)
                    }));
                });
                if (!_.isUndefined(deleteLabelcards) && !_.isEmpty(deleteLabelcards) && deleteLabelcards !== null) {
                    _.each(deleteLabelcards, function(card) {
                        var label = card.labels.filter(function(model) {
                            return parseInt(model.get('label_id')) === parseInt(self.label_id);
                        });
                        card.labels.remove(label, {
                            silent: false
                        });
                        if (!_.isUndefined(card.attributes.cards_labels) && !_.isEmpty(card.attributes.cards_labels) && card.attributes.cards_labels !== null && card.attributes.cards_labels.length > 0) {
                            var card_attr_labels = card.attributes.cards_labels.filter(function(label) {
                                return parseInt(label.label_id) === parseInt(self.label_id);
                            });
                            if (card_attr_labels.length > 0) {
                                var card_attr_labels_index = card.attributes.cards_labels.indexOf(card_attr_labels[0]);
                                card.attributes.cards_labels.splice(card_attr_labels_index, 1);
                            }
                        }
                    });
                }
                var filter_labels = self.model.labels.filter(function(model) {
                    return parseInt(model.get('label_id')) === parseInt(self.label_id);
                });
                self.model.labels.remove(filter_labels, {
                    silent: false
                });
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
