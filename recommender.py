import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from flask import Flask, request, jsonify

app = Flask(__name__)

def process_events(event_list):
    df = pd.DataFrame(event_list)

    R = df['rating']
    v = df['sold']
    C = R.mean()
    m = v.quantile(0.9)

    df['weighted_average'] = ((R * v) + (C * m)) / (v + m)

    scaler = MinMaxScaler()
    scaled = scaler.fit_transform(df[['weighted_average', 'sold']])
    df[['normalized_weight_average', 'normalized_qtysold']] = scaled

    df['score'] = df['normalized_weight_average'] * 0.5 + df['normalized_qtysold'] * 0.5
    df = df.sort_values(by='score', ascending=False)

    indices = pd.Series(df.index, index=df['title']).drop_duplicates()
    top_5_indices = indices.head(5).index.tolist()

    qty_ranking = df.sort_values('sold', ascending=False)
    indices_qty = pd.Series(qty_ranking.index, index=qty_ranking['title']).drop_duplicates()
    bottom50_qty = indices_qty.tail(5).index
    common_bottom5_final_qty = list(bottom50_qty.intersection(indices.tail(5).index))[:5]

    rating_ranking = df.sort_values('weighted_average', ascending=False)
    indices_rating = pd.Series(rating_ranking.index, index=rating_ranking['title']).drop_duplicates()
    bottom50_rating = indices_rating.tail(5).index
    common_bottom5_rating_final = list(bottom50_rating.intersection(indices.tail(5).index))[:5]
    
    top_5_events = df[df['title'].isin(top_5_indices)].to_dict(orient='records')
    bottom_qty_events = df[df['title'].isin(common_bottom5_final_qty)].to_dict(orient='records')
    bottom_rating_events = df[df['title'].isin(common_bottom5_rating_final)].to_dict(orient='records')


    return {
        "top_5_indices": top_5_events,
        "common_bottom5_final_qty": bottom_qty_events,
        "common_bottom5_rating_final": bottom_rating_events
    }

@app.route('/recommend', methods=['POST'])
def recommend():
    try:
        data = request.get_json()
        if not data or 'result' not in data:
            return jsonify({"error": "Missing 'result' field in JSON"}), 400

        events_list = data['result']

        if not events_list:
            return jsonify({"error": "Empty event list"}), 400

        df_processed = process_events(events_list)

        return jsonify({
            "result": df_processed,
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
